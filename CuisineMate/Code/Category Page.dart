import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class CP extends StatefulWidget {
  const CP({super.key});

  @override
  State<CP> createState() => _CPState();
}

class _CPState extends State<CP> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _newCuisineController = TextEditingController();
  final TextEditingController _newSubcategoryController = TextEditingController();
  Uint8List? _uploadedImage;
  final ImagePicker _picker = ImagePicker();

  List<String> _cuisines = ["Italian", "Chinese", "Indian", "Mexican"];
  List<String> _selectedCuisines = [];
  List<String> _subcategories = ["Starters", "Desserts"];
  List<String> _selectedSubcategories = [];
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

  Future<void> _saveCategories() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/db.json');
      final data = {'categories': _categories};
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint("Error saving categories: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        setState(() {
          _uploadedImage = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image. Please try again.")),
      );
    }
  }

  void _addCuisine() {
    final newCuisine = _newCuisineController.text.trim();
    if (newCuisine.isNotEmpty && !_cuisines.contains(newCuisine)) {
      setState(() {
        _cuisines.add(newCuisine);
      });
      _newCuisineController.clear();
    }
  }

  void _addSubcategory() {
    final newSubcategory = _newSubcategoryController.text.trim();
    if (newSubcategory.isNotEmpty && !_subcategories.contains(newSubcategory)) {
      setState(() {
        _subcategories.add(newSubcategory);
      });
      _newSubcategoryController.clear();
    }
  }

  void _submitCategory() async {
    final String title = _titleController.text.trim();

    if (title.isEmpty || _uploadedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload an image.")),
      );
      return;
    }

    if (_selectedCuisines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one cuisine.")),
      );
      return;
    }

    if (_selectedSubcategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one subcategory.")),
      );
      return;
    }

    final imageBase64 = base64Encode(_uploadedImage!);

    final newCategory = {
      'title': title,
      'image': imageBase64,
      'cuisines': _selectedCuisines,
      'subcategories': _selectedSubcategories,
    };

    setState(() {
      _categories.add(newCategory);
    });

    await _saveCategories();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Category added successfully!")),
    );

    Navigator.pop(context);
  }

  Future<void> _deleteCategory(int index) async {
    setState(() {
      _categories.removeAt(index);
    });

    // Save the updated categories list to db.json
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/db.json');
      final data = {'categories': _categories};
      await file.writeAsString(jsonEncode(data));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category deleted successfully!")),
      );
    } catch (e) {
      debugPrint("Error deleting category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Category", style: GoogleFonts.poppins(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Title Input
            TextField(
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(15), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Category Title",
                labelStyle: GoogleFonts.poppins(color: Colors.black),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Image Upload Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: _uploadedImage != null
                      ? DecorationImage(
                    image: MemoryImage(_uploadedImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _uploadedImage == null
                    ? Center(child: Text("Tap to upload an image", style: GoogleFonts.poppins(color: Colors.black, fontSize: 17)))
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Cuisine Section
            Text("Cuisines:", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: _cuisines.map((cuisine) {
                final isSelected = _selectedCuisines.contains(cuisine);
                return FilterChip(
                  label: Text(cuisine, style: GoogleFonts.poppins()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCuisines.add(cuisine);
                      } else {
                        _selectedCuisines.remove(cuisine);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCuisineController,
                    decoration: InputDecoration(
                      labelText: "Add Cuisine",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addCuisine,
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Subcategory Section (Placed below cuisines and displayed horizontally)
            Text("Subcategories:", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: _subcategories.map((subcategory) {
                final isSelected = _selectedSubcategories.contains(subcategory);
                return FilterChip(
                  label: Text(subcategory, style: GoogleFonts.poppins()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSubcategories.add(subcategory);
                      } else {
                        _selectedSubcategories.remove(subcategory);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSubcategoryController,
                    decoration: InputDecoration(
                      labelText: "Add Subcategory",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addSubcategory,
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitCategory,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),minimumSize: const Size(180, 50)),
                child: Text("Submit Category", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20.0),

            // Display Existing Categories
            Text("Existing Categories:", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            _categories.isEmpty
                ? const Center(child: Text("No categories available"))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteCategory(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
