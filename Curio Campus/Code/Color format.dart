import 'package:flutter/material.dart';

Color head = Colors.orange;

Color appcolor  = Color(0xff0d6ba1);
Color Buttoncolor = Color(0xff41b7ed);
Color Textcolor = Color(0xffabe5e9);

TextStyle cct = TextStyle(fontSize: 35,fontWeight: FontWeight.bold);


class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Toggle theme mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Flip the current state
    notifyListeners(); // Notify all listeners of the change
  }

  // Get current theme mode
  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}