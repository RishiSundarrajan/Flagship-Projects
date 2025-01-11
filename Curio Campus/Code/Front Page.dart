import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:curio/Share%20Skills.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'About us and Feedback.dart';
import 'Color format.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curio/Category%20Page.dart';

class frontpage extends StatefulWidget {
  final String gname;
  final String gmail;
  final String photourl;
  final String loggedInPhone;
  const frontpage({super.key, required this.gmail, required this.photourl, required this.loggedInPhone, required this.gname});

  @override
  State<frontpage> createState() => _frontpageState();
}

class _frontpageState extends State<frontpage> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  List content = [
    "Curio Campus, where knowledge meets opportunity! Our platform is designed to connect individuals eager to learn with those passionate about teaching.",
    "Connect face-to-face : Connect face-to-face with our dynamic video chat feature! Whether you're seeking instant support, engaging in live consultations, or simply catching up with friends.",
    "Recorded Videos : Enhance your skills with our interactive training video! Engage with interactive exercises, real-time feedback, and practical scenarios that help you apply what you’ve learned.",
    "Live chat : We're here to help you with any questions or support you might need. Whether you’re looking for product information or assistance, our team is ready to assist you in real-time.",
  ];
  void initState() {
    super.initState();
    _fetchUsername();
  }
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

  String username = "";
  Future<void> _fetchUsername() async {
    try {
      final response = await http.get(
          Uri.parse("http://49.204.232.254:90/users/getbyphonenumber/${widget.loggedInPhone}")
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Data: $data');

        // Assuming the API returns a field named 'username'
        setState(() {
          username = data['data']['username'] ?? "Unknown User";
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

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color frontpagetheme = themeNotifier.isDarkMode ? Colors.black : Colors.indigo;
    Color frontcontent = themeNotifier.isDarkMode ? Colors.white10 : Colors.blueAccent;
    Color Button = themeNotifier.isDarkMode ? Colors.white10 : Colors.black;
    Color border = themeNotifier.isDarkMode ? Colors.grey : Colors.black;

    // Update displayName logic to prioritize Google name (gname) over API-fetched username
    String displayName = widget.gname.isNotEmpty ? widget.gname : (username.isNotEmpty ? username : "User");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(height: 40, width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("Assets/CurioCampus.png"))
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EmojiFeedback()));
            },child: Icon(Icons.feedback_outlined, size: 30, color: Colors.black,)),
          ),
        ],
      ),
      backgroundColor: frontpagetheme,
      body:  isLoading
          ? CircularProgressIndicator() // Show a loading indicator while fetching
          : SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (widget.photourl.isNotEmpty) // Only show if photourl is provided
                  //   CircleAvatar(
                  //     radius: 30,
                  //     backgroundImage: NetworkImage(widget.photourl),
                  //     backgroundColor: Colors.transparent,
                  //   ),
                  SizedBox(width: 15),
                  Text("Hello, ", style: GoogleFonts.poppins(fontSize: 22, color: TextColor)),
                  Text(displayName, style: GoogleFonts.poppins(fontSize: 22, color: TextColor)),
                ],
              ),
              SizedBox(height: 15,),
              Text("Welcome to Curio Campus", style: GoogleFonts.poppins(color: TextColor, fontSize: 22)),
              SizedBox(height: 20,),
              CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 185,
                    aspectRatio: 16/9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4 ),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                    // onPageChanged: callbackFunction,
                  ), itemCount: content.length, itemBuilder: (BuildContext context, int index, int realIndex) {
                    return Container(
                      height: 200,
                      width: 400,
                      child: Text(content[index], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),),
                    );
                },
              ),
              Card(elevation: 10,color: frontcontent,
                child: Container(height: 460, width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Top Categories", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600)),
                    TextButton(onPressed: (){
                      _getcategory('development'); // Fetch 'development' category
                    }, child: Text("Development", style: GoogleFonts.poppins(color: Colors.white70,fontSize: 22))),
                    TextButton(onPressed: (){
                      _getcategory('creativity');
                    }, child: Text("Creativity", style: GoogleFonts.poppins(color: Colors.white70,fontSize: 22))),
                    TextButton(onPressed: (){
                      _getcategory('music');
                    }, child: Text("Music", style: GoogleFonts.poppins(color: Colors.white70,fontSize: 22))),
                    TextButton(onPressed: (){
                      _getcategory('photography');
                    }, child: Text("Photography", style: GoogleFonts.poppins(color: Colors.white70,fontSize: 22))),
                    TextButton(onPressed: (){
                      _getcategory('gaming');
                    }, child: Text("Gaming", style: GoogleFonts.poppins(color: Colors.white70,fontSize: 22))),
                  ],
                ),),
              ),
              SizedBox(height: 20,),
              TextButton(style:TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), minimumSize: const Size(200, 60), backgroundColor: Button) ,onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SS(loggedInPhone: widget.loggedInPhone,)));
              }, child: Text("Share Your Skills", style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)))
            ],
                    ),
          )
              // : Center(child: Text("No user data found", style: GoogleFonts.poppins(fontSize: 22))),
      );
  }
}

///
// void initState(){
// super.initState();
// _getalluser();
// }
// ///getall user
// var GAU = {};
// var data=[];
// _getalluser()async{
//   final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));
//   print(response.statusCode);
//   if(response.statusCode == 200 || response.statusCode == 201){
//     setState(() {
//       GAU = json.decode(response.body)["data"];
//       // GAU = json.decode(response.body);
//       // data=GAU[0]["id"];
//       // Navigator.push(context, MaterialPageRoute(builder: (context)=>CV()));
//       print(GAU["data"]);
//     });
//   }
// }

///
// var GAU = [];
// var data = [];
// _getalluser() async {
//   final response = await http.get(Uri.parse("http://49.204.232.254:90/users/getall"));
//   print(response.statusCode);
//   print(response.body);  // Print the entire body to check if it's correct.
//
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     setState(() {
//       GAU = json.decode(response.body)["data"];
//       print("Full API Response: $GAU");
//       print("Logged in Phone Number: ${widget.loggedInPhone}");
//
//       // Filter to find the logged-in user
//       data = GAU.where((user) {
//         print("Checking User Phone: ${user["phone"]}");
//         return user["phone"] == widget.loggedInPhone;
//       }).toList();
//
//       print("Filtered User Data: $data");
//       isLoading = false;  // Stop loading once data is fetched
//     });
//   } else {
//     print('Failed to fetch data. Status: ${response.statusCode}');
//     setState(() {
//       isLoading = false;  // Stop loading if an error occurs
//     });
//   }
// }