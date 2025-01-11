import 'dart:convert';
import 'package:curio/Category%20Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import 'Color format.dart';

class SP extends StatefulWidget {
  final String loggedInPhone;
  const SP({super.key, required this.loggedInPhone});

  @override
  State<SP> createState() => _CPState();
}

class _CPState extends State<SP> {
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
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 35,),
            Container(
              //alignment: Alignment.center,
              height: 50,
              width: 430,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.poppins(color: TextColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: border, width: 1.5)
                    )
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('development'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 118,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Development", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500)),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('music'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Music", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('creativity'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Creativity", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('art'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Arts", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('dance'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Dance", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('photography'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 115,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Photography", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500)),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('uiux'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("UI-UX", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(onTap: (){
                    _getcategory('gaming'); // Fetch 'development' category
                  },
                    child: Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border.all(color: border, width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Gaming", style: GoogleFonts.poppins(color: TextColor, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 165,),
            Container(
              height: 250,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("Assets/Search1.gif"))
              ),
            )
          ],
        ),
      ),
    );
  }
}
