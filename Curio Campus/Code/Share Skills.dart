import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class SS extends StatefulWidget {
  final String loggedInPhone;
  const SS({super.key, required this.loggedInPhone});

  @override
  State<SS> createState() => _SSState();
}

class _SSState extends State<SS> {
  String? pdfFileName = "No file chosen"; // Stores chosen pdf file name
  String? pdfFilePath; // Variable to store the path of the uploaded PDF file
  Uint8List? pdfFileBytes; // Variable to store the bytes of the uploaded PDF file
  bool isCertificateUploaded = false; // Track certificate upload status
  String? pdfErrorMessage; // Error message for wrong file format for PDF
  bool isSubmitted = false;  // Tracks if the button has been clicked
  bool CertificateButtonEnabled = true;
  String? selectedCategory;
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  TextEditingController _languageController = TextEditingController();
  List<String> languages = ["Tamil", "English", "Hindi"]; // Available languages
  List<String> selectedLanguages = []; // Stores selected languages
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Languages", style: GoogleFonts.poppins()),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: languages.map((String language) {
                    return CheckboxListTile(
                      title: Text(language, style: GoogleFonts.poppins()),
                      value: selectedLanguages.contains(language),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedLanguages.add(language);
                          } else {
                            selectedLanguages.remove(language);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
                child: Text("Cancel", style: GoogleFonts.poppins())),
            TextButton(
              onPressed: () {
                setState(() {
                  _languageController.text = selectedLanguages.join(', ');
                });
                Navigator.of(context).pop();
              },
              child: Text("OK", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
  final TextEditingController _qualificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> choosePdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files
    );

    if (result != null) {
      pdfFileBytes = result.files.first.bytes;
      pdfFileName = result.files.first.name;
      print("PDF file chosen: $pdfFileName");

      if (pdfFileName!.endsWith('.pdf')) {
        setState(() {
          isCertificateUploaded = true; // Mark file as uploaded
        });
      } else {
        setState(() {
          isCertificateUploaded = false; // Mark file as not uploaded
        });
      }
    }
  }

  // Method to submit data to the API
  Future<void> sendToApi() async {
    final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add text fields to the request
    request.fields['skillname'] = _skillController.text.trim();
    request.fields['experiences'] = _experienceController.text.trim();
    request.fields['qualifications'] = _qualificationController.text.trim();
    request.fields['languages'] = selectedLanguages.join(','); // Ensure this is a comma-separated string

    // Adding the PDF file
    if (pdfFileBytes != null) {
      // Automatically detect the MIME type based on the file name
      String mimeType = lookupMimeType(pdfFileName!) ?? 'application/pdf'; // Default to PDF if not found

      request.files.add(http.MultipartFile.fromBytes(
        'certificates', // Field name expected by the server
        pdfFileBytes!, // PDF file bytes
        filename: pdfFileName, // Original file name
        contentType: MediaType.parse(mimeType), // Use the detected MIME type
      ));

      print('PDF file added to the request: $pdfFileName');
    } else {
      print('No PDF file to send.');
    }

    // Send the request
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Upload successful!');
        // Handle success
      } else {
        print('Upload failed with status: ${response.statusCode}');
        // Handle failure
      }
    } catch (e) {
      print('Error occurred: $e');
      // Handle error
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // All validations passed, call the API
      setState(() {
        CertificateButtonEnabled = false; // Disable the button after submission
      });
      sendToApi(); // Call your API function
    } else {
      // Optionally, you can show a message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  String? videoFileName = "No file chosen"; // Stores chosen video file name
  bool isVideoUploaded = false; // Track video upload status
  String? videoErrorMessage; // Error message for wrong file format for Video
  bool isSubmitted1 = false;  // Tracks if the button has been clicked
  bool VideoButtonEnabled = true;
  final TextEditingController _videoNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  Uint8List? videoBytes;
  String? fileName;

  void submitFormvideo() async {
    // Step 2: Validate the form
    if (_formKey1.currentState!.validate()) {
      if (!isVideoUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No video file has been uploaded. Please upload a video.')),
        );
        return;
      }
      // Step 3: Disable the button and show submission progress
      setState(() {
        isSubmitted1 = true;
        VideoButtonEnabled = false; // Disable the button during submission
      });
      // Step 4: Call the API to upload the video
      try {
        await uploadVideo(); // Ensure this method is async and returns a Future

        // Handle success response here (e.g., show a success message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully!')),
        );
      } catch (error) {
        // Handle error response here (e.g., show an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video. Please try again.')),
        );
      } finally {
        // Step 5: Re-enable the button after processing
        setState(() {
          VideoButtonEnabled = true; // Re-enable the button after processing
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
    }
  }

  Future<void> chooseVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      if (result.files.single.extension == 'mp4' ||
          result.files.single.extension == 'avi' ||
          result.files.single.extension == 'mkv') {
        setState(() {
          videoFileName = result.files.single.name;
          videoErrorMessage = null;
          isVideoUploaded = true;

          // Store video bytes and filename for web
          videoBytes = result.files.single.bytes;
          fileName = result.files.single.name;
        });
      } else {
        setState(() {
          videoErrorMessage = "Wrong file format. Please select a valid video file.";
        });
      }
    }
  }

  Future<void> uploadVideo() async {
    final String apiUrl = 'http://49.204.232.254:90/videos/upload';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add text fields to the request
    request.fields['videoName'] = _videoNameController.text.trim();
    request.fields['description'] = _descriptionController.text.trim();
    request.fields['duration'] = _durationController.text.trim();
    request.fields['uploadedBy'] = widget.loggedInPhone; // Assuming this is the phone number field

    // Logging request fields for debugging
    print('Video Name: ${_videoNameController.text.trim()}');
    print('Description: ${_descriptionController.text.trim()}');
    print('Duration: ${_durationController.text.trim()}');
    print('Video File Name: $videoFileName');
    print('Is Video Uploaded: $isVideoUploaded');

    if (kIsWeb) {
      // For Web: Add video bytes
      if (videoBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No video file selected.')),
        );
        return;
      }

      request.files.add(http.MultipartFile.fromBytes(
        'video',
        videoBytes!,
        filename: fileName!,
      ));
    } else {
      // For Mobile: Add video file from path
      if (isVideoUploaded) {
        request.files.add(await http.MultipartFile.fromPath(
          'video',
          videoFileName!, // Path to the video file
        ));
      }
    }

    // Send the request
    try {
      final response = await request.send();

      // Log the status code for debugging
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Upload successful!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully!')),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Upload failed with status: ${response.statusCode}');
        print('Response body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $responseBody')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(key: _formKey,
            child: Column(
              children: [
                Align(),
                Card(
                  elevation: 10,
                  child: Container(
                    height: 650,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: !isSubmitted,
                            controller: _skillController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Skill Name',
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Skill Name",
                              labelStyle: GoogleFonts.poppins(color: TextColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: border)
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: 'development',
                                      child: Text('development', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'music',
                                      child: Text('music', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'creativity',
                                      child: Text('creativity', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'art',
                                      child: Text('art', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'dance',
                                      child: Text('dance', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'photography',
                                      child: Text('photography', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'uiux',
                                      child: Text('uiux', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'gaming',
                                      child: Text('gaming', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                  onChanged: isSubmitted ? null : (value) {
                                    setState(() {
                                      selectedCategory = value;
                                      _skillController.text = selectedCategory!;
                                    });
                                  },
                                  hint: Text("Select Skill", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                  underline: SizedBox(), // Removes default underline
                                  iconEnabledColor: TextColor,  // Changes icon color
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: !isSubmitted,
                            controller: _experienceController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                            validator: (input) {
                              if (input == null || input.isEmpty || !RegExp(r'^[0-9]{1,5}$').hasMatch(input)) {
                                return 'Please enter a valid duration';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Experience',
                                hintStyle: GoogleFonts.poppins(color: TextColor),
                                labelText: "Experience",
                                labelStyle: GoogleFonts.poppins(color: TextColor),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: border)
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: !isSubmitted,
                            controller: _languageController,
                            readOnly: true, // Prevent user from typing
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                            decoration: InputDecoration(
                              hintText: 'Languages',
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Languages",
                              labelStyle: GoogleFonts.poppins(color: TextColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: border)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.arrow_drop_down, color: TextColor),
                                onPressed: isSubmitted ? null : _showLanguageDialog,  // Disable after submit, // Show dialog on button press
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: !isSubmitted,
                            controller: _qualificationController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                            validator: (input) {
                              if (!RegExp(r"^[A-Za-z]{3,}(?:[-'][A-Za-z]+)*$").hasMatch(input!)) {
                                return 'Please enter a valid data';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Qualifications',
                                hintStyle: GoogleFonts.poppins(color: TextColor),
                                labelText: "Qualifications",
                                labelStyle: GoogleFonts.poppins(color: TextColor),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: border)
                                )
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Upload Certificate", style: GoogleFonts.poppins(color: TextColor,fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            width: 400,
                            decoration: BoxDecoration(
                                border: Border.all(color: border),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: isSubmitted ? null : choosePdfFile,  // Disable after submit,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      minimumSize: const Size(90, 47),
                                      backgroundColor: Colors.black,
                                    ),
                                    child: Text("Choose files", style: GoogleFonts.poppins(color: TextColor1)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    pdfFileName ?? "No file chosen",
                                    style: GoogleFonts.poppins(textStyle: TextStyle(overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w500)),
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (pdfErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              pdfErrorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (!CertificateButtonEnabled) return; // Prevent action if the button is disabled
                            if (_formKey.currentState!.validate()) {
                              if (isCertificateUploaded) {
                                setState(() {
                                  isSubmitted = true;  // Mark the form as submitted
                                  submitForm(); // This will also disable the button now
                                });
                                return; // Exit the function if no file is uploaded
                              }
                            } else {
                              // If any field is not filled, show error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill all fields.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            minimumSize: const Size(130, 55),
                            backgroundColor: Colors.black,
                          ),
                          child: Text("Submit", style: GoogleFonts.poppins(color: TextColor1)),
                        ),
                        if (isSubmitted)  // Conditionally show the text if the button is clicked
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Approval Pending", style: GoogleFonts.poppins(color: TextColor, fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Center(child: Text("Upload Your Video", style: GoogleFonts.poppins(color: TextColor, fontSize: 20, fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 10,
                  child: Container(
                    height: 570,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Form(key: _formKey1,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: !isSubmitted1,
                              controller: _videoNameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                              validator: (input) {
                                if (!RegExp(r"^[A-Za-z]{3,}(?:[-'][A-Za-z]+)*$").hasMatch(input!)) {
                                  return 'Please enter a valid name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Video Name',
                                  hintStyle: GoogleFonts.poppins(color: TextColor),
                                  labelText: "Video Name",
                                  labelStyle: GoogleFonts.poppins(color: TextColor),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: border)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: !isSubmitted1,
                              controller: _descriptionController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                              validator: (input) {
                                if (!RegExp(r"^[A-Za-z]{3,}(?:[-'][A-Za-z]+)*$").hasMatch(input!)) {
                                  return 'Please enter a valid description';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: GoogleFonts.poppins(color: TextColor),
                                  labelText: "Description",
                                  labelStyle: GoogleFonts.poppins(color: TextColor),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: border)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: !isSubmitted1,
                              controller: _durationController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
                              validator: (input) {
                                if (input == null || input.isEmpty || !RegExp(r'^[0-9]{1,5}$').hasMatch(input)) {
                                  return 'Please enter a valid duration';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Duration (In Seconds)',
                                  hintStyle: GoogleFonts.poppins(color: TextColor),
                                  labelText: "Duration (In Seconds)",
                                  labelStyle: GoogleFonts.poppins(color: TextColor),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: border)
                                  )
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Select Video", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              width: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(color: border),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: isSubmitted1 ? null :  chooseVideoFile,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        minimumSize: const Size(90, 47),
                                        backgroundColor: Colors.black,
                                      ),
                                      child: Text("Select Video", style: GoogleFonts.poppins(color: TextColor1)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      videoFileName ?? "No file chosen", style: GoogleFonts.poppins(textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500)),
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (videoErrorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                videoErrorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (!VideoButtonEnabled) return; // Prevent action if the button is disabled
                              if (_formKey1.currentState!.validate()) {
                                if (isVideoUploaded) {
                                  setState(() {
                                    submitFormvideo(); // Directly call the submit method
                                  });
                                } else {
                                  // If the file is not uploaded, show an error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No video file has been uploaded. Please upload a video.')),
                                  );
                                }
                              } else {
                                // If any field is not filled, show error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill all fields.')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              minimumSize: const Size(130, 55),
                              backgroundColor: Colors.black,
                            ),
                            child: Text("Submit", style: GoogleFonts.poppins(color: TextColor1)),
                          ),
                          if (isSubmitted1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Approval Pending", style: GoogleFonts.poppins(color: TextColor, fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ///postvideo by user
// var PVU = {};
// List data = [];
// _postvideobyuser()async{
//   final response = await http.get(Uri.parse("http://49.204.232.254:90/videos/upload"));
//   print(response.statusCode);
//   if(response.statusCode == 200 || response.statusCode == 201){
//     setState(() {
//       PVU = json.decode(response.body);
//       data = json.decode(response.body)["data"];
//     });
//   }
// }

// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       if (isCertificateUploaded)
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text("Uploaded successfully",style: GoogleFonts.poppins(color: CupertinoColors.activeGreen)),
//         ),
//       ElevatedButton(
//         onPressed: uploadCertificate,
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           minimumSize: const Size(10, 47),
//           backgroundColor: Colors.black,
//         ),
//         child: Text("Upload Certificate", style: GoogleFonts.poppins(color: TextColor1)),
//       ),
//     ],
//   ),
// ),
// Future<void> uploadCertificate() async {
//   // Simulate a certificate upload process
//   if (pdfFileName != "No file chosen" && pdfErrorMessage == null) {
//     setState(() {
//       isCertificateUploaded = true; // Mark certificate as uploaded
//     });
//   }
// }

///
// Future<void> choosePdfFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf'], // Only allow PDF files
//   );
//   if (result != null) {
//     // Check if the selected file is a PDF
//     if (result.files.single.extension == 'pdf') {
//       setState(() {
//         pdfFilePath = result.files.single.path;
//         pdfFileName = result.files.single.name;
//         pdfErrorMessage = null; // Reset error message
//         isCertificateUploaded = true; // Reset upload status
//       });
//     } else {
//       setState(() {
//         pdfErrorMessage = "Wrong file format. Please select a PDF."; // Show error
//         isCertificateUploaded = false; // Set to false if wrong format
//       });
//     }
//   }
// }
//
// // Method to submit data to the API
// Future<void> sendToApi() async {
//   final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';
//   // Adjust the fields according to your API requirements
//   final formData = {
//     'skillname': _skillController.text.trim(), // Ensure skill name is trimmed
//     'experiences': _experienceController.text.trim(), // Ensure experience is trimmed
//     'qualifications': _qualificationController.text.trim(), // Ensure qualifications are trimmed
//     'languages': selectedLanguages, // Send as a list (not a string)
//     'certificates': pdfFilePath != null ? [pdfFilePath] : [], // Ensure it's an array
//   };
//   print("FormData: $formData"); // Log the data to check
//   try {
//     final response = await http.post(Uri.parse(apiUrl),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(formData), // Convert the data to JSON
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Form submitted successfully!')),
//       );
//     } else {
//       print("Error: ${response.statusCode}");
//       print("Response body: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
//       );
//     }
//   } catch (error) {
//     print("Error occurred: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $error')),
//     );
//   }
// }
//
// void submitForm() {
//   if (_skillController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please select a skill.')),
//     );
//     return;
//   }
//
//   if (_experienceController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please enter your experience.')),
//     );
//     return;
//   }
//
//   if (selectedLanguages.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please select at least one language.')),
//     );
//     return;
//   }
//
//   if (_qualificationController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please enter your qualifications.')),
//     );
//     return;
//   }
//
//   if (!isCertificateUploaded) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please upload a certificate.')),
//     );
//     return;
//   }
//   // All validations passed, call the API
//   sendToApi();
// }

///
// Method to submit data to the API
//   Future<void> sendToApi() async {
//     final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';
//
//     // Create a multipart request
//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//     // Add the fields to the request
//     final formData = {
//       'skillname': _skillController.text.trim(),
//       'experiences': _experienceController.text.trim(),
//       'qualifications': _qualificationController.text.trim(),
//       'languages': selectedLanguages,  // Ensure this is sent as an array
//       'certificates': pdfFileName != null ? [pdfFileName] : [], // Ensure it's an array
//     };
//     print("FormData: $formData");
//     // Add the PDF file to the request if it exists
//     if (pdfFileBytes != null) {
//       request.files.add(http.MultipartFile.fromBytes(
//         'certificates', // The name of the field on the server
//         pdfFileBytes!, // The bytes of the PDF
//         filename: pdfFileName, // The name of the file
//       ));
//       print('Certificate file added: $pdfFileName');
//     } else {
//       print('No certificate file to send.');
//     }
//     print("Sending to API:");
//     print("Skill Name: ${_skillController.text.trim()}");
//     print("Experiences: ${_experienceController.text.trim()}");
//     print("Qualifications: ${_qualificationController.text.trim()}");
//     print("Languages: ${selectedLanguages}");
//     print("PDF File Name: $pdfFileName");
//
//     // Send the request
//     try {
//       final response = await request.send();
//       // Handle the response
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Form submitted successfully!')),
//         );
//       } else {
//         print("Error: ${response.statusCode}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
//         );
//       }
//     } catch (error) {
//       print("Error occurred: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $error')),
//       );
//     }
//   }

///
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       if (isVideoUploaded)
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Text("Uploaded successfully", style: GoogleFonts.poppins(color: CupertinoColors.activeGreen),
//               ),
//             ],
//           ),
//         ),
//       ElevatedButton(
//         onPressed: uploadVideo,
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           minimumSize: const Size(10, 47),
//           backgroundColor: Colors.black,
//         ),
//         child: Text("Upload Video", style: GoogleFonts.poppins(color: TextColor1)),
//       ),
//     ],
//   ),
// ),

///latest
// Uint8List? pdfFileBytes; // Variable to store the bytes of the uploaded PDF file
//
// Future<void> choosePdfFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf'], // Only allow PDF files
//   );
//   if (result != null && result.files.isNotEmpty) {
//     // Get the file bytes
//     final bytes = result.files.single.bytes;
//     if (bytes != null) {
//       setState(() {
//         pdfFileName = result.files.single.name;
//         pdfFileBytes = bytes; // Store the bytes for later use
//         pdfErrorMessage = null; // Reset error message
//         isCertificateUploaded = true; // Reset upload status
//       });
//       print('PDF file chosen: $pdfFileName');
//     } else {
//       setState(() {
//         pdfErrorMessage = "Error reading the file.";
//         isCertificateUploaded = false; // Set to false if reading fails
//       });
//     }
//   } else {
//     setState(() {
//       pdfErrorMessage = "No file selected."; // Show error if no file is selected
//       isCertificateUploaded = false;
//     });
//   }
// }
//
// Future<void> sendToApi() async {
//   final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';
//   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//   // Add text fields
//   request.fields['skillname'] = _skillController.text.trim();
//   request.fields['experiences'] = _experienceController.text.trim();
//   request.fields['qualifications'] = _qualificationController.text.trim();
//   request.fields['languages'] = jsonEncode(selectedLanguages.isNotEmpty ? selectedLanguages : []);
//
//   // Add the PDF file to 'certificates'
//   if (pdfFileBytes != null) {
//     request.files.add(http.MultipartFile.fromBytes(
//       'certificates',
//       pdfFileBytes!,
//       filename: pdfFileName?.replaceAll(' ', '_'),
//     ));
//     print('Certificate file added: $pdfFileName');
//   }
//
//   try {
//     final response = await request.send();
//     final responseBody = await http.Response.fromStream(response);
//
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${responseBody.body}");
//
//     if (!mounted) return; // Add this to ensure the widget is still active
//
//     if (response.statusCode == 200) {
//       print('Upload successful!');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Form submitted successfully!')),
//         );
//       }
//     } else {
//       print('Upload failed with status: ${response.statusCode}');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
//         );
//       }
//     }
//   } catch (error) {
//     print("Error occurred: $error");
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $error')),
//       );
//     }
//   }
// }
//
// void submitForm() {
//   if (_skillController.text.isEmpty ||
//       _experienceController.text.isEmpty ||
//       selectedLanguages.isEmpty ||
//       _qualificationController.text.isEmpty ||
//       !isCertificateUploaded) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all fields and upload a certificate.')),
//     );
//     return;
//   }
//     if (_skillController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a skill.')),
//       );
//       return;
//     }
//     if (_experienceController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter your experience.')),
//       );
//       return;
//     }
//     if (selectedLanguages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select at least one language.')),
//       );
//       return;
//     }
//     if (_qualificationController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter your qualifications.')),
//       );
//       return;
//     }
//   if (!isCertificateUploaded) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please upload a certificate.')),
//     );
//     return;
//   }
//   // All validations passed, call the API
//   sendToApi();
// }

///
// Future<void> chooseVideoFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.video, // Only allow video files
//   );
//   if (result != null) {
//     // Check if a valid video file is selected
//     if (result.files.single.extension == 'mp4' ||
//         result.files.single.extension == 'avi' ||
//         result.files.single.extension == 'mkv') {
//       setState(() {
//         videoFileName = result.files.single.name;
//         videoErrorMessage = null; // Reset error message
//         isVideoUploaded = false; // Reset upload status
//       });
//     } else {
//       setState(() {
//         videoErrorMessage = "Wrong file format. Please select a valid video file."; // Show error
//       });
//     }
//   }
// }
//
// Future<void> uploadVideo() async {
//   // Simulate a video upload process
//   if (videoFileName != "No file chosen" && videoErrorMessage == null) {
//     setState(() {
//       isVideoUploaded = true; // Mark video as uploaded
//     });
//   }
// }

/// working
// Future<void> choosePdfFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf'], // Only allow PDF files
//   );
//   if (result != null && result.files.isNotEmpty) {
//     // Get the file bytes
//     final bytes = result.files.single.bytes;
//     if (bytes != null) {
//       setState(() {
//         pdfFileName = result.files.single.name;
//         pdfFileBytes = bytes; // Store the bytes for later use
//         pdfErrorMessage = null; // Reset error message
//         isCertificateUploaded = true; // Reset upload status
//       });
//       print('PDF file chosen: $pdfFileName');
//     } else {
//       setState(() {
//         pdfErrorMessage = "Error reading the file.";
//         isCertificateUploaded = false; // Set to false if reading fails
//       });
//     }
//   } else {
//     setState(() {
//       pdfErrorMessage = "No file selected."; // Show error if no file is selected
//       isCertificateUploaded = false;
//     });
//   }
// }
//
// Future<void> sendToApi() async {
//   final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';
//
//   // Create a map of form data
//   final formData = {
//     'skillname': _skillController.text.trim(),
//     'experiences': _experienceController.text.trim(),
//     'qualifications': _qualificationController.text.trim(),
//     'languages': selectedLanguages.join(','), // Convert list to a comma-separated string
//   };
//   print("FormData: $formData"); // Log the data to check
//
//   try {
//     // Send the form data as JSON
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(formData), // Convert the data to JSON
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Form submitted successfully!')),
//       );
//     } else {
//       print("Error: ${response.statusCode}");
//       print("Response body: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
//       );
//     }
//   } catch (error) {
//     print("Error occurred: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $error')),
//     );
//   }
// }

///
// Uint8List? pdfFileBytes;

//   Future<void> choosePdfFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf'], // Only allow PDF files
//   );
//   if (result != null && result.files.isNotEmpty) {
//     // Get the file bytes
//     final bytes = result.files.single.bytes;
//     if (bytes != null) {
//       setState(() {
//         pdfFileName = result.files.single.name;
//         pdfFileBytes = bytes; // Store the bytes for later use
//         pdfErrorMessage = null; // Reset error message
//         isCertificateUploaded = true; // Reset upload status
//       });
//       print('PDF file chosen: $pdfFileName');
//     } else {
//       setState(() {
//         pdfErrorMessage = "Error reading the file.";
//         isCertificateUploaded = false; // Set to false if reading fails
//       });
//     }
//   } else {
//     setState(() {
//       pdfErrorMessage = "No file selected."; // Show error if no file is selected
//       isCertificateUploaded = false;
//     });
//   }
// }
//
//   Future<void> sendToApi() async {
//     final String apiUrl = 'http://49.204.232.254:90/users/updateskills/${widget.loggedInPhone}';
//
//     // Create a map of form data
//     final formData = {
//       'skillname': _skillController.text.trim(),
//       'experiences': _experienceController.text.trim(),
//       'qualifications': _qualificationController.text.trim(),
//       'languages': selectedLanguages.join(','), // Convert list to a comma-separated string
//     };
//     print("FormData: $formData"); // Log the data to check
//
//     try {
//       // Send the form data as JSON
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(formData), // Convert the data to JSON
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Form submitted successfully!')),
//         );
//       } else {
//         print("Error: ${response.statusCode}");
//         print("Response body: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
//         );
//       }
//     } catch (error) {
//       print("Error occurred: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $error')),
//       );
//     }
//   }

// Function to pick PDF file



// Function to pick PDF file