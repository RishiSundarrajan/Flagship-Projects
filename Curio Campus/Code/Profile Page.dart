import 'dart:convert';
import 'dart:io';
import 'package:curio/Bottom%20Navigation.dart';
import 'package:curio/Interactive%20Pages.dart';
import 'package:curio/Login%20Page.dart';
import 'package:curio/Share%20Skills.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'About us and Feedback.dart';
import 'Color format.dart';
import 'package:http/http.dart' as http;

class PP extends StatefulWidget {
  final String gname;
  final String gmail;
  final String photourl;
  final String loggedInPhone;
  const PP({super.key, required this.loggedInPhone, required this.gname, required this.gmail, required this.photourl});

  @override
  State<PP> createState() => _PPState();
}

class _PPState extends State<PP> {
  final String dynamicLink = "https://flutter.dev/";
  String? imgPath;
  File? imgFile;

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getImg() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      saveData(pickedImage.path.toString()); // path cache
      setState(() {
        imgFile = File(pickedImage.path);
      });
    }
  }
  Future<void> saveData(String val) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('path', val);
    print("Data saved to SharedPreferences:");
    print("Path: $val");
    setState(() {
      imgPath = val;
    });
    getData();
  }
  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Retrieving data from SharedPreferences...");
    setState(() {
      imgPath = preferences.getString('path');
    });
  }
  _delete() async {
    setState(() {
      imgPath=null;
      saveData("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color icon = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color wb = themeNotifier.isDarkMode ? Colors.black12 : Colors.white;
    Color bw = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 120,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Curio Campus', style: GoogleFonts.poppins(color: TextColor)),
                        Text('Learn, Share, Grow', style: GoogleFonts.poppins(color: TextColor)),
                      ],
                    )
                ),
              ),
              ListTile(
                title:  Text('Home', style: GoogleFonts.poppins(color: TextColor)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BN(loggedInPhone: widget.loggedInPhone, gmail: widget.gmail, photourl: widget.photourl, gname: widget.gname,)));
                },
              ),
              ListTile(
                title:  Text('Dark Mode', style: GoogleFonts.poppins(color: TextColor)),
                trailing: Switch(
                  value: themeNotifier.isDarkMode,
                  onChanged: (value) {
                    themeNotifier.toggleTheme();
                  },
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text('Share Your Skills', style: GoogleFonts.poppins(color: TextColor)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SS(loggedInPhone: widget.loggedInPhone,)));
                },
              ),
              // ListTile(
              //   title: Text('App Setting', style: GoogleFonts.poppins(color: TextColor)),
              //   onTap: () {
              //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));
              //   },
              // ),
              ListTile(
                title: Text('About Us', style: GoogleFonts.poppins(color: TextColor)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>about()));
                },
              ),
              ListTile(
                title: Text('Help', style: GoogleFonts.poppins(color: TextColor)),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));
                },
              ),
              ListTile(
                title: Text('Logout', style: GoogleFonts.poppins(color: TextColor)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white, // Clean background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Soft rounded corners
                        ),
                        elevation: 8, // Soft shadow effect
                        title: Text("Are you sure you want to Logout?", style: GoogleFonts.poppins(color: TextColor1)),
                        contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0), // Adjust content padding
                        actionsPadding: EdgeInsets.only(bottom: 10.0, right: 10.0), // Bottom spacing for actions
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Smooth corner buttons
                              ),
                              foregroundColor: Colors.grey[700], // Text color
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel", style: GoogleFonts.poppins(color: TextColor1, fontSize: 15)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple, // Updated backgroundColor for button
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Smooth corner buttons
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LP()),
                                      (Route<dynamic> route) => false);
                            }, child: Text("Logout", style: GoogleFonts.poppins(color: TextColor)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  imgPath == null
                      ? Container(
                    height: 190,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.photourl.isNotEmpty ? NetworkImage(widget.photourl) : AssetImage("Assets/5.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                      : Container(
                    height: 170,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                          image: NetworkImage(imgPath!), // Use network image
                          fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,  // Positioning near the bottom of the image
                    right: 10,   // Aligning to the right edge
                    child: GestureDetector(
                      onTap: () {
                        getImg();  // Add your image picking function here
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,  // Circular container color
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12,),
                        ),
                        child: Icon(Icons.edit, size: 24, color: icon),  // The edit icon
                      ),
                    ),
                  ),
                ],
              ),
              Align(alignment: Alignment.center,),
              SizedBox(height: 25,),
              GestureDetector(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EP(loggedInPhone: widget.loggedInPhone, gname: widget.gname, gmail: widget.gmail, photourl: widget.photourl,)));
              },
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue,),
                  title: Text("Edit Profile", style: GoogleFonts.poppins(color: bw, fontSize: 18, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_ios, color: bw,),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>IPV(loggedInPhone: widget.loggedInPhone,)));
              },
                child: ListTile(
                  leading: Icon(Icons.video_settings_outlined, color: Colors.red,),
                  title: Text("My Videos", style: GoogleFonts.poppins(color: bw, fontSize: 18, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_ios, color: bw,),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>IPC(loggedInPhone: widget.loggedInPhone,)));
              },
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf_outlined, color: Colors.brown,),
                  title: Text("My Certificates / Notifications", style: GoogleFonts.poppins(color: bw, fontSize: 18, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_ios, color: bw,),
                ),
              ),
              SizedBox(height: 40,),
              Card(elevation: 10,
                child: Container(
                  height: 220,
                  width: 400,
                  decoration: BoxDecoration(
                    color: wb,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Invite Friends", style: GoogleFonts.poppins(fontSize: 25,color: bw),),
                      Text("Share link with your friends", style: GoogleFonts.poppins(fontSize: 19,color: bw)),
                      IconButton(onPressed: (){
                        Share.share(dynamicLink);
                      }, icon: Icon(Icons.ios_share_outlined, size: 40,color: bw,))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EP extends StatefulWidget {
  final String gname;
  final String gmail;
  final String photourl;
  final String loggedInPhone;
  const EP({super.key, required this.loggedInPhone, required this.gname, required this.gmail, required this.photourl});

  @override
  State<EP> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EP> {
  File? selectedImage;
  String fileName = "No file chosen";
  bool isUploaded = false; // Track if the image is uploaded
  bool userdata = false;
  bool isLoading = false;
  String username = "";
  String email = "";
  String phonenumber = "";

  @override
  void initState() {
    super.initState();
    // _fetchUsername();
    _getalluser();
    // Determine the display name and email based on login method
    if (widget.gname.isNotEmpty && widget.gmail.isNotEmpty) {
      // User logged in through Google
      username = widget.gname; // Use Google name as username
      email = widget.gmail; // Use Gmail directly
      phonenumber = widget.loggedInPhone; // Use the phone number passed
      isLoading = false; // Stop loading once data is set
    } else {
      // User logged in through standard signup, fetch details from API
      _fetchUsername();
    }
  }
  var GAU = [];
  var data = [];
  _getalluser() async {
    final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));
    print(response.statusCode);
    print(response.body);  // Print the entire body to check if it's correct.
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        GAU = json.decode(response.body)["data"];
        print("Full API Response: $GAU");
        print("Logged in Phone Number: ${widget.loggedInPhone}");
        // Filter to find the logged-in user
        data = GAU.where((user) {
          print("Checking User Phone: ${user["phone"]}");
          return user["phone"] == widget.loggedInPhone;
        }).toList();
        print("Filtered User Data: $data");
        isLoading = false;  // Stop loading once data is fetched
      });
    } else {
      print('Failed to fetch data. Status: ${response.statusCode}');
      setState(() {
        isLoading = false;  // Stop loading if an error occurs
      });
    }
  }
  Future<void> _fetchUsername() async {
    try {
      final response = await http.get(
          Uri.parse("http://49.204.232.254:90/users/getbyphonenumber/${widget.loggedInPhone}"));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Data: $data');
        // Assuming the API returns a field named 'username'
        setState(() {
          username = data['data']['username'];
          email = data['data']['email'];
          phonenumber = data['data']['phonenumber'];
          isLoading = false;
        });
      } else {
        print("Error fetching username: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> chooseFile() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        fileName = pickedImage.name;  // Update the text with the file name
        isUploaded = false; // Reset upload status
      });
    }
  }
  Future<void> uploadImage() async {
    if (selectedImage != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('path', selectedImage!.path);  // Save the selected image path
      setState(() {
        isUploaded = true; // Mark as uploaded
      });
    }
  }
  void submit() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PP(loggedInPhone: widget.loggedInPhone, gname: widget.gname, gmail: widget.gmail, photourl: widget.photourl,))); // Navigate back to PP
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color TextColor2 = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color button = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile", style: GoogleFonts.poppins(color: TextColor)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(),
            SizedBox(height: 30,),
            Card(elevation: 10,
              child: Container(
                height: 570,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //color: Colors.red
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: userdata,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: username.isNotEmpty ? username : "Username",
                          hintStyle: GoogleFonts.poppins(color: TextColor),
                          // labelText: "Username"
                          // labelStyle: GoogleFonts.poppins(color: TextColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: border)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: userdata,
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: email.isNotEmpty ? email : "User email",
                            hintStyle: GoogleFonts.poppins(color: TextColor),
                            // labelText: "User email"
                            // labelStyle: GoogleFonts.poppins(color: TextColor),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: border)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: userdata,
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: phonenumber.isNotEmpty ? phonenumber : "User phonenumber",
                            hintStyle: GoogleFonts.poppins(color: TextColor),
                            // labelText: "User phonenumber",
                            // labelStyle: GoogleFonts.poppins(color: TextColor),
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
                          child: Text("Upload Image", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500)),
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
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(onPressed: (){
                                chooseFile();
                              },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), minimumSize: const Size(90, 47), backgroundColor: button), child: Text("Choose files", style: GoogleFonts.poppins(color: TextColor2))),
                            ),
                            Expanded(
                              child: Text(fileName ?? "No file chosen",
                                style: GoogleFonts.poppins(textStyle: TextStyle(overflow: TextOverflow.ellipsis,  fontWeight: FontWeight.w500)),
                                maxLines: 1,
                                softWrap: false,),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              if (isUploaded)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Uploaded successfully", style: GoogleFonts.poppins(color: CupertinoColors.activeGreen)),
                                ),
                              ElevatedButton(onPressed: (){
                                uploadImage();
                              }, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), minimumSize: const Size(10, 47), backgroundColor: button), child: Text("Upload Image", style: GoogleFonts.poppins(color: TextColor2))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: submit, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), minimumSize: const Size(130, 55), backgroundColor: button), child: Text("Submit", style: GoogleFonts.poppins(color: TextColor2)))
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

///
// int _selectedIndex = 0;
// static const TextStyle optionStyle =
// TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
// static const List<Widget> _widgetOptions = <Widget>[
//   Text(
//     'Index 0: Home',
//     style: optionStyle,
//   ),
//   Text(
//     'Index 1: Business',
//     style: optionStyle,
//   ),
//   Text(
//     'Index 2: School',
//     style: optionStyle,
//   ),
// ];
//
// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }

// ListTile(
//   title: const Text('Business'),
//   selected: _selectedIndex == 1,
//   onTap: () {
//     // Update the state of the app
//     _onItemTapped(1);
//     // Then close the drawer
//     Navigator.pop(context);
//   },
// ),

// ///getvideo by user
// var GAU = {};
// List data1 = [];
// _getvideobyuser()async{
//   final response = await http.get(Uri.parse("http://localhost:8080/videos/get/9843787375"));
//   print(response.statusCode);
//   if(response.statusCode == 200 || response.statusCode == 201){
//     setState(() {
//       GAU = json.decode(response.body);
//       data1 = json.decode(response.body)["data"];
//     });
//   }
// }

// Future<void> fetchUserData() async {
//   setState(() {
//     isLoading = true;
//   });
//
//   try {
//     print("Fetching user data for phone number: ${widget.loggedInPhone}"); // Debugging
//     final response = await http.get(
//       Uri.parse("http://49.204.232.254:90/users/getbyphonenumber/${widget.loggedInPhone}"),
//       headers: {"content-type": "application/json"},
//     );
//     print("Response status code: ${response.statusCode}"); // Debugging
//     print("Response body: ${response.body}"); // Debugging
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       // Adjust these keys based on your actual API response
//       username = data['data']['username'] ?? "Unknown User";
//       email = data['data']['email'];
//
//       setState(() {}); // Update the UI with the fetched data
//     } else {
//       print("Error: ${response.statusCode}");
//       // Optionally show an error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load user data: ${response.statusCode}')),
//       );
//     }
//   } catch (e) {
//     print("Error fetching user data: $e");
//     // Optionally show an error message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $e')),
//     );
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }