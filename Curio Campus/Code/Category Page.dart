import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curio/Color%20format.dart';
import 'package:curio/ComingSoonPage.dart';
import 'package:curio/Interactive%20Pages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CP extends StatefulWidget {
  final String loggedInPhone;
  const CP({super.key, required this.loggedInPhone});

  @override
  State<CP> createState() => _CPState();
}

class _CPState extends State<CP> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  // Variable to hold selected skill name
  String? selectedSkill;
  List categories = []; // Declare categories as a List
  // Fetch all categories based on the user's phone and selected skill
  Future<void> _getcategory(String skillName) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch data based on skill
      final response = await http.get(
        Uri.parse("http://49.204.232.254:90/users/getskillname/$skillName"),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        // Filter out the logged-in user's details
        List filteredCategories = responseData["data"].where((category) {
          return category["phone"] != widget.loggedInPhone;
        }).toList();
        setState(() {
          categories = filteredCategories;
          isLoading = false;
          // Navigate to the CV screen with the filtered categories
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CV(
                selectedSkill: skillName,
                categories: categories, loggedInPhone: widget.loggedInPhone,
              ),
            ),
          );
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching category: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
    Color textColor = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color bg = themeNotifier.isDarkMode ? Colors.black : appcolor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryCard("development", "Assets/development.png", "development"),
                    _buildCategoryCard("music", "Assets/music.png", "music"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryCard("creativity", "Assets/creativity.png", "creativity"),
                    _buildCategoryCard("art", "Assets/art.png", "art"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryCard("dance", "Assets/dance.png", "dance"),
                    _buildCategoryCard("photography", "Assets/photograph.png", "photography"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryCard("uiux", "Assets/ui_ux.png", "uiux"),
                    _buildCategoryCard("gaming", "Assets/gaming.png", "gaming"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Helper method to build category cards
  Widget _buildCategoryCard(String skillName, String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (_formkey.currentState!.validate()) {
            setState(() {
              isLoading = true;
              _getcategory(skillName).whenComplete(() {
                setState(() {
                  isLoading = false;
                });
              });
            });
          }
        },
        child: Card(
          elevation: 20,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(image: AssetImage(imagePath)),
                  ),
                ),
                SizedBox(height: 10),
                Text(title, style: GoogleFonts.poppins(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CV extends StatefulWidget {
  const CV({
    super.key,
    required this.selectedSkill, // Accept selected skill
    required this.categories, required String loggedInPhone,
  });
  final String selectedSkill; // Add selectedSkill property
  final List<dynamic> categories; // Keep categories as it is

  @override
  State<CV> createState() => _CVState();
}

class _CVState extends State<CV> {
  var data = [];
  List filteredData = []; // New list for filtered users
  List skills = [];
  List languages = [];

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        data = json.decode(response.body)["data"]; // Accessing 'data' key
        // Filter users based on the selected skill
        filteredData = data.where((user) {
          // Extract the user's skills
          List userSkills = user["skills"];
          // Check if any of the user's skills match the selected skill
          return userSkills.any((skill) => skill["skillname"] == widget.selectedSkill);
        }).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color card = themeNotifier.isDarkMode ? Colors.black12 : Colors.white;
    Color textColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color iconColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: filteredData.isEmpty
          ? Center(
        child: Text(
          "No users found with the selected skill",
          style: GoogleFonts.poppins(color: textColor),
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: filteredData.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              var user = filteredData[index];
              skills = user["skills"];
              var selectedUserSkill = skills.firstWhere((skill) =>
              skill["skillname"] == widget.selectedSkill);
              languages = selectedUserSkill["languages"];
              var languageList = languages.toList();
              return Center(
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 500,
                    width: 380,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 210,
                          width: 160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/4.jpg"),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          user["username"].toString(), // Display the username
                          style: GoogleFonts.poppins(color: textColor, fontSize: 20),
                        ),
                        SizedBox(height: 5),
                        Text(
                          selectedUserSkill["skillname"].toString(), // Display the selected skill
                          style: GoogleFonts.poppins(color: textColor, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ComingSoonPage()));
                              },
                              icon: Icon(Icons.message_outlined, color: iconColor, size: 55),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ComingSoonPage()));
                              },
                              icon: Icon(Icons.video_call_outlined, color: iconColor, size: 80),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => IPV(loggedInPhone: '')));
                              },
                              icon: Icon(Icons.video_settings_outlined, color: iconColor, size: 60),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Languages", style: GoogleFonts.poppins(
                                      color: textColor, fontSize: 20),
                                ),
                                Text(
                                  languageList.join(', '), style: GoogleFonts.poppins(
                                      color: textColor, fontSize: 17),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Qualification", style: GoogleFonts.poppins(
                                      color: textColor, fontSize: 20),
                                ),
                                Text(
                                  selectedUserSkill["qualifications"].toString(),
                                  style: GoogleFonts.poppins(color: textColor, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 605,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}

///
// class CV extends StatefulWidget {
//   const CV({super.key, required String selectedSkill, required List<dynamic> categories});
//
//   @override
//   State<CV> createState() => _CVState();
// }
//
// class _CVState extends State<CV> {
//   var data = [];
//   List skills = [];
//   List languages=[];
//   @override
//   void initState() {
//     super.initState();
//     _getAllUsers();
//   }
//
//   Future<void> _getAllUsers() async {
//     final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));
//     print(response.statusCode);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       setState(() {
//         data = json.decode(response.body)["data"]; // Accessing 'data' key
//         print(data); // Check if data is loaded
//       });
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }
//
//   ///getall user
//   // var GAU = {};
//   // List data1 = [];
//   // _getalluser()async{
//   //   final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));
//   //   print(response.statusCode);
//   //   if(response.statusCode == 200 || response.statusCode == 201){
//   //     setState(() {
//   //       GAU = json.decode(response.body);
//   //       data = json.decode(response.body)["data"];
//   //       Navigator.push(context, MaterialPageRoute(builder: (context)=>CV()));
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeNotifier = Provider.of<ThemeNotifier>(context);
//     Color card = themeNotifier.isDarkMode ? Colors.black12 : Colors.white;
//     Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
//     Color icon = themeNotifier.isDarkMode ? Colors.white : Colors.black;
//     Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CarouselSlider.builder(
//             itemCount: data.length,
//             itemBuilder: (BuildContext context, int index, int realIndex) {
//               var user=data[index];
//               skills= user["skills"];
//               languages=user["skills"][index]["languages"];
//               var l=languages.toList();
//               print(l);
//               return Center(
//                 child: Card(elevation: 10,
//                   child: Container(
//                     height: 500,
//                     width: 380,
//                     decoration: BoxDecoration(
//                         color: card,
//                         borderRadius: BorderRadius.circular(5)
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 210,
//                           width: 160,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(image: AssetImage("assets/4.jpg")),
//                               shape: BoxShape.circle
//                           ),
//                         ),
//                         Text(data[index]["username"].toString(), style: GoogleFonts.poppins(color: TextColor, fontSize: 20)),
//                         SizedBox(height: 5,),
//                         Text(skills[0]["skillname"].toString(), style: GoogleFonts.poppins(color: TextColor, fontSize: 16)),
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 SizedBox(height: 5,),
//                                 IconButton(onPressed: (){
//                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
//                                 }, icon: Icon(Icons.message_outlined,color: icon, size: 55,),)
//                               ],
//                             ),
//                             IconButton(onPressed: (){
//
//                             }, icon: Icon(Icons.video_call_outlined,color: icon, size: 80,)),
//                             IconButton(onPressed: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=>IPV(loggedInPhone: '',)));
//                             }, icon: Icon(Icons.video_settings_outlined,color: icon, size: 60,))
//                           ],
//                         ),
//                         SizedBox(height: 25,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 Text("Languages", style: GoogleFonts.poppins(color: TextColor, fontSize: 20)),
//                                 Text(l.toString(), style: GoogleFonts.poppins(color: TextColor, fontSize: 17)),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Text("Qualification", style: GoogleFonts.poppins(color: TextColor, fontSize: 20)),
//                                 Text(skills[0]["qualifications"].toString(), style: GoogleFonts.poppins(color: TextColor, fontSize: 16)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               height: 605,
//               aspectRatio: 16/9,
//               viewportFraction: 1,
//               initialPage: 0,
//               enableInfiniteScroll: true,
//               reverse: false,
//               autoPlay: true,
//               autoPlayInterval: Duration(seconds: 4 ),
//               autoPlayAnimationDuration: Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enlargeCenterPage: true,
//               enlargeFactor: 0.3,
//               scrollDirection: Axis.horizontal,
//               // onPageChanged: callbackFunction,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }