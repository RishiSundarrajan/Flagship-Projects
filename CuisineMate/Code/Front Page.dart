import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Category Page.dart';
import 'package:flutter/foundation.dart';

class FP extends StatefulWidget {
  const FP({super.key});

  @override
  State<FP> createState() => _FPState();
}

class _FPState extends State<FP> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/db.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        setState(() {
          _categories = List<Map<String, dynamic>>.from(data['categories']);
        });
      }
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }

  Future<void> _navigateToCreateCategory() async {
    // Navigate to the Create Category page
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CP()),
    );
    // Reload categories after returning
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("CuisineMate", style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: _navigateToCreateCategory,
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: Colors.black,minimumSize: const Size(200, 50),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: Text(
                  "Create Category",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: _categories.isEmpty
                  ? Center(
                child: Text(
                  "No categories available. Please create some in the Create Category page.",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final image = base64Decode(category['image']);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(image),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      title: Text(
                        category['title'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cuisines: ${category['cuisines'].join(', ')}",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            "Subcategories: ${category['subcategories'].join(', ')}",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}






