import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JSONHelper {
  static const String _fileName = 'db.json';
  // Get file path
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }
  // Load categories from JSON
  static Future<List<Map<String, dynamic>>> loadCategories() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        return List<Map<String, dynamic>>.from(data['categories']);
      } else {
        return []; // Return an empty list if the file doesn't exist
      }
    } catch (e) {
      print("Error loading categories: $e");
      return [];
    }
  }
  // Save categories to JSON
  static Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    try {
      final file = await _getFile();
      final data = {'categories': categories};
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print("Error saving categories: $e");
    }
  }
}
