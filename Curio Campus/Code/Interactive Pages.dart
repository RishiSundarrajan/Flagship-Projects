import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'Color format.dart';
import 'package:url_launcher/url_launcher.dart';

class IPV extends StatefulWidget {
  final String loggedInPhone;
  const IPV({super.key, required this.loggedInPhone});

  @override
  State<IPV> createState() => _IPVState();
}
class _IPVState extends State<IPV> {
  List<FlickManager> flickManagers = [];
  List<String> videoUrls = [];
  List<String> titles = [];
  List<String> descriptions = [];
  List<String> durations = [];
  bool _isDataFetched = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    _getvideobyuser();
  }
  @override
  void dispose() {
    // Dispose of all FlickManagers
    for (var manager in flickManagers) {
      manager.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  // Fetch videos uploaded by the user
  _getvideobyuser() async {
    final response = await http.get(Uri.parse("http://49.204.232.254:90/videos/get/${widget.loggedInPhone}"));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        setState(() {
          var data1 = json.decode(response.body)["videos"];
          // Extract details from the response
          for (var video in data1) {
            String videoUrl = "http://49.204.232.254:90" + (video["video"] ?? '');
            videoUrls.add(videoUrl);
            titles.add(video["videoName"] ?? "Untitled Video");
            descriptions.add(video["description"] ?? "No description available");
            durations.add(video["duration"].toString() + " seconds");
            FlickManager flickManager = FlickManager(
              videoPlayerController: VideoPlayerController.network(videoUrl),
            );
            // Add a listener to each video to track its play/pause state
            flickManager.flickVideoManager?.addListener(() {
              setState(() {
                _isPlaying = flickManager.flickVideoManager!.isPlaying;
              });
            });
            flickManagers.add(flickManager);
          }
          _isDataFetched = true;
        });
      } catch (e) {
        print("Error parsing JSON: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse video data.', style: GoogleFonts.poppins())),
        );
      }
    } else {
      setState(() {
        _isDataFetched = true;
      });
      print("Failed to fetch videos with status code: ${response.statusCode}");
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.', style: GoogleFonts.poppins())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load videos. Please check your connection.', style: GoogleFonts.poppins())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("My Videos", style: GoogleFonts.poppins(fontSize: 18)),
      ),
      body: !_isDataFetched
          ? Center(child: CircularProgressIndicator())
          : videoUrls.isEmpty
          ? Center(child: Text("No videos found", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18)))
          : Column(
          children: [
          Align(),
          SizedBox(height: 30),
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 470,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: !_isPlaying,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: videoUrls.length,  // Number of videos
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Card(
                elevation: 10,
                color: Color(0xFFEDC9AF), // Approximate sandal color (light beige/tan)
                child: Container(
                  height: 500,
                  width: 415,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,  // Maintain 16:9 aspect ratio
                          child: FlickVideoPlayer(
                            flickManager: flickManagers[index],
                            flickVideoWithControls: FlickVideoWithControls(
                              controls: FlickPortraitControls(),
                            ),
                            preferredDeviceOrientationFullscreen: [
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.landscapeLeft,
                            ],
                            systemUIOverlayFullscreen: [
                              SystemUiOverlay.top,
                              SystemUiOverlay.bottom,
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(titles[index], style: GoogleFonts.poppins(color: TextColor1, fontSize: 17)),
                        SizedBox(height: 20),
                        Text(descriptions[index], style: GoogleFonts.poppins(color: TextColor1, fontSize: 17)),
                        SizedBox(height: 20),
                        Text("Duration: ${durations[index]}", style: GoogleFonts.poppins(color: TextColor1, fontSize: 17)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class IPC extends StatefulWidget {
  final String loggedInPhone;
  const IPC({super.key, required this.loggedInPhone});

  @override
  State<IPC> createState() => _IPCState();
}

class _IPCState extends State<IPC> {
  var GAU = {};
  List skills = []; // Store fetched skills data
  bool isLoading = true; // Loading state
  bool hasError = false; // Error state
  String errorMessage = ""; // To hold error messages

  /// Fetches user data based on the logged-in phone number
  _getUserData() async {
    try {
      // API call with the logged-in phone number
      final response = await http.get(
          Uri.parse("http://49.204.232.254:90/users/getbyphonenumber/${widget.loggedInPhone}"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          GAU = json.decode(response.body);
          skills = GAU["data"]["skills"] is List ? GAU["data"]["skills"] : []; // Extract skills
          // Ensure certificates are treated as List<String>
          for (var skill in skills) {
            if (skill['certificates'] is List) {
              skill['certificates'] = List<String>.from(skill['certificates']);
            }
          }
          isLoading = false; // Data fetched successfully
        });
      } else {
        setState(() {
          hasError = true; // Error if status is not OK
          errorMessage = "Error: ${response.statusCode}"; // Detailed error message
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        hasError = true;
        errorMessage = "Failed to fetch data: $error"; // Detailed error message
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the widget is initialized
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    /// Method to show a dialog with the list of certificate URLs
    void _showCertificatesDialog(List<String> certificateUrls) {
      if (certificateUrls.isEmpty) {
        // Show a message if no certificates are available
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("No Certificates Found", style: GoogleFonts.poppins(fontSize: 22, color: Textcolor)),
              content: Text("There are no certificates available for this skill.", style: GoogleFonts.poppins(fontSize: 18, color: Textcolor)),
              actions: [
                TextButton(
                  child: Text("Close", style: GoogleFonts.poppins(fontSize: 15, color: Colors.indigo)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
        return; // Exit early since there are no certificates
      }
      // Proceed to show the dialog with the list of certificates if they exist
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Available Certificates", style: GoogleFonts.poppins(fontSize: 22, color: TextColor)),
            content: SingleChildScrollView(
              child: ListBody(
                children: certificateUrls.map((url) {
                  return ListTile(
                    title: Text(
                        url.split('/').last, style: GoogleFonts.poppins(fontSize: 19, color: TextColor)), // Show only the filename
                    onTap: () {
                      _viewCertificate(url);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text("Close", style: GoogleFonts.poppins(fontSize: 15, color: Colors.indigo)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("My Certificates", style: GoogleFonts.poppins(fontSize: 18)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : hasError
          ? Center(
          child: Text(
          errorMessage, // Show detailed error message
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ) // Show error message on failure
          : skills.isNotEmpty
          ? ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: skills.length,
          itemBuilder: (context, index) {
          var skill = skills[index];
          return Card(
            elevation: 10,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Color(0xFFEDC9AF), // Sandal color
            child: ListTile(
              leading: Icon(Icons.star, color: Colors.brown),
              title: Text(
                skill['skillname'] ?? "Unknown Skill", // Bind skill name
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              onTap: () {
                // Show certificates when skill is tapped
                _showCertificatesDialog(skill['certificates'] ?? []);
              },
            ),
          );
        },
      )
          : Center(child: Text("No certificates found.", style: GoogleFonts.poppins(fontSize: 18, color: TextColor)),
      ),
    );
  }
  /// Method to open a specific certificate URL
  void _viewCertificate(String certificateUrl) async {
    String fullUrl = "http://49.204.232.254:90" + certificateUrl;
    if (await canLaunch(fullUrl)) {
      await launch(fullUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the certificate URL.", style: GoogleFonts.poppins(fontSize: 22, color: Colors.black))),
      );
    }
  }
}

///
// @override
// void initState() {
//   super.initState();
//   _getvideobyuser();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
//   flickManager = FlickManager(
//     videoPlayerController: VideoPlayerController.networkUrl(
//       Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
//     ),
//   );
// }
//
// @override
// void dispose() {
//   flickManager.dispose();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   super.dispose();
// }

// ///get all video
// var GAV = {};
// List video = [];
// List languages=[];
// _getallvideo()async{
//   final response = await http.get(Uri.parse("http://49.204.232.254:90/videos/getall"));
//   print(response.statusCode);
//   if(response.statusCode == 200 || response.statusCode == 201){
//     setState(() {
//       GAV = json.decode(response.body);
//       video = json.decode(response.body);
//       //Navigator.push(context, MaterialPageRoute(builder: (context)=>CV()));
//     });
//   }
// }

// FlickManagers for each video

///
// class IPC extends StatefulWidget {
//   final String loggedInPhone;
//   const IPC({super.key, required this.loggedInPhone});
//
//   @override
//   State<IPC> createState() => _IPCState();
// }
//
// class _IPCState extends State<IPC> {
//
//   ///getcertificate
//   var GAU = {};
//   List data1 = []; // This will store the fetched certificates data
//   bool isLoading = true; // Loading state
//   bool hasError = false; // Error state
//   _getcertificate() async {
//     try {
//       final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getbyphonenumber/${widget.loggedInPhone}"));
//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         setState(() {
//           GAU = json.decode(response.body);
//           data1 = json.decode(response.body)["data"] ?? []; // Fetch "data" field, handle null case
//           isLoading = false; // Mark data as loaded
//         });
//         print("Fetched data: $data1");
//       } else {
//         setState(() {
//           hasError = true; // Mark error if response status isn't OK
//           isLoading = false;
//         });
//         print("Error: Response returned with status code ${response.statusCode}");
//       }
//     } catch (error) {
//       setState(() {
//         hasError = true;
//         isLoading = false;
//       });
//       print("Error fetching data: $error");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getcertificate(); // Fetch certificates when the widget is initialized
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 30,),
//           Align(),
//           Container(width: 410,
//             child: Card(
//               elevation: 10,
//               color: Color(0xFFEDC9AF), // Approximate sandal color (light beige/tan)
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                 mainAxisSize: MainAxisSize.min, // Card adjusts its height dynamically
//                 children: [
//                   SizedBox(height: 10),
//                   // Dynamically display skill names and handle certificate viewing
//                   data1.isNotEmpty
//                       ? ListView.builder(
//                     shrinkWrap: true, // So the ListView doesn't take up infinite space
//                     physics: NeverScrollableScrollPhysics(), // Disable scrolling as we are using inside a column
//                     itemCount: data1.length,
//                     itemBuilder: (context, index) {
//                       var certificate = data1[index];
//                       return ListTile(
//                         leading: Icon(Icons.picture_as_pdf_outlined, color: Colors.brown),
//                         title: Text(
//                           certificate['skillName'], // Bind the skill name from the API data
//                           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.arrow_forward_ios),
//                           onPressed: () {
//                             // Code to view/download the certificate
//                             _viewCertificate(certificate['certificateUrl']);
//                           },
//                         ),
//                       );
//                     },
//                   ) : Center(child: CircularProgressIndicator()), // Loading indicator while fetching data
//                   SizedBox(height: 10),
//                 ],
//               ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   void _viewCertificate(String certificateUrl) {
//     // Assuming the certificate is a PDF, you can open it using a URL launcher or any PDF viewer
//     if (certificateUrl.isNotEmpty) {
//       launchUrl(Uri.parse(certificateUrl));
//     } else {
//       // Handle case where there's no certificate URL
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No certificate available")));
//     }
//   }
// }

///
// @override
// void dispose() {
//   // Dispose of all FlickManagers
//   for (var manager in flickManagers) {
//     manager.dispose();
//   }
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   super.dispose();
// }