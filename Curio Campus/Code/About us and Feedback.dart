import 'package:curio/Bottom%20Navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color buttonColor = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color BC = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Align(alignment: Alignment.center,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('CurioCampus', style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.bold, color: TextColor)),
                      SizedBox(height: 20),
                      Text('Info', style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 10),
                      Text('About Us', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Compressions', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Customers', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Service', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Collection', style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 30),
                      Text('Explore', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: TextColor)),
                      SizedBox(height: 10),
                      Text('Free Designs', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Latest Designs', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Themes', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Popular Designs', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Art Skills', style: GoogleFonts.poppins(color: TextColor)),
                      Text('New Uploads', style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 30),
                      Text('Legal', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: TextColor)),
                      SizedBox(height: 10),
                      Text('Customer Agreement', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Privacy Policy', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Security', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Testimonials', style: GoogleFonts.poppins(color: TextColor)),
                      Text('Media Kit', style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 20),
                      Text('Newsletter', style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 10),
                      Text('Subscribe to our newsletter for a weekly dose of news, updates, helpful tips, and exclusive offers.',
                        textAlign: TextAlign.center, style: GoogleFonts.poppins(color: TextColor)),
                      SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (input) {
                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+.[a-zA-Z]+").hasMatch(input!)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          prefixIcon: Icon(Icons.email, color: BC,),
                          hintText: "Email",
                          hintStyle: GoogleFonts.poppins(color: TextColor),
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(color: TextColor)
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: buttonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), minimumSize: Size(120, 45)),
                        onPressed: () {},
                        child: Text('SUBSCRIBE', style: GoogleFonts.poppins(color: TextColor1))),
                      SizedBox(height: 20),
                      Text('By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy and Content Policies. All trademarks are properties of their respective owners. 2024 © CurioCampus™ Ltd. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: TextColor)),
                    ],
                  )),//CREDITS
                SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiFeedback extends StatefulWidget {
  @override
  _EmojiFeedbackState createState() => _EmojiFeedbackState();
}
class _EmojiFeedbackState extends State<EmojiFeedback> {
  String _selectedEmoji = '';
  final TextEditingController _commentController = TextEditingController();
  Widget _emojiButton(String emoji, String feedbackType) {
    final bool isSelected = _selectedEmoji == feedbackType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmoji = feedbackType;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 40,
            color: feedbackType == "Angry"
                ? Colors.red         // Red color for Angry
                : feedbackType == "Neutral"
                ? Colors.grey    // Grey color for Neutral
                : feedbackType == "Happy"
                ? Colors.green  // Green color for Happy
                : feedbackType == "Loved it"
                ? Colors.pink  // Pink color for Loved it
                : Colors.black,  // Default color for emoji
          ),
        ),
      ),
    );
  }
  void _submitFeedback() {
    if (_selectedEmoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an emoji before submitting.", style: GoogleFonts.poppins(color: Textcolor)),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thank You", style: GoogleFonts.poppins()),
          content: Text("Your Feedback means a lot to us.", style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BN(loggedInPhone: '', gmail: '', photourl: '', gname: '',)));  // Close dialog
                //_resetForm();  // Reset form after submission
              },
              child: Text("OK", style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color TextColor1 = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    return Scaffold(
      appBar: AppBar(title: Text("Feedback", style: GoogleFonts.poppins(color: TextColor))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("How was your experience?", style: GoogleFonts.poppins(color: TextColor)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _emojiButton("😡", "Angry"),
                _emojiButton("😐", "Neutral"),
                _emojiButton("😊", "Happy"),
                _emojiButton("😍", "Loved it"),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _selectedEmoji.isEmpty ? "No feedback selected" : "You selected: $_selectedEmoji",
              style: GoogleFonts.poppins(color: TextColor),
            ),
            SizedBox(height: 20),
            Text("Leave a comment (optional):", style: GoogleFonts.poppins(color: TextColor)),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your feedback...",
                hintStyle: GoogleFonts.poppins(color: TextColor),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  minimumSize: const Size(200, 50)),
              child: Text("Submit Feedback", style: GoogleFonts.poppins(color: TextColor1)),
            ),
          ],
        ),
      ),
    );
  }
}

///
// class FeedbackForm extends StatefulWidget {
//   @override
//   _FeedbackFormState createState() => _FeedbackFormState();
// }
//
// class _FeedbackFormState extends State<FeedbackForm> {
//   double _rating = 0;
//   final TextEditingController _commentController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Feedback Form")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Rate your experience:", style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             RatingBar.builder(
//               initialRating: _rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//               itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             Text("Leave a comment (optional):"),
//             TextField(
//               controller: _commentController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Your feedback...",
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle feedback submission
//                 },
//                 child: Text("Submit Feedback"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EmojiFeedback extends StatefulWidget {
//   @override
//   _EmojiFeedbackState createState() => _EmojiFeedbackState();
// }
//
// class _EmojiFeedbackState extends State<EmojiFeedback> {
//   String _selectedEmoji = '';  // Stores the selected emoji feedback type
//   final TextEditingController _commentController = TextEditingController();
//
//   // Method to build each emoji button
//   Widget _emojiButton(String emoji, String feedbackType) {
//     final bool isSelected = _selectedEmoji == feedbackType;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedEmoji = feedbackType;  // Update selected emoji type
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,  // Highlight selected emoji
//           shape: BoxShape.circle,
//         ),
//         child: Text(
//           emoji,
//           style: TextStyle(
//             fontSize: 40,
//             color: isSelected ? Colors.blue : Colors.black,  // Change color if selected
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Method to handle feedback submission with validation
//   void _submitFeedback() {
//     if (_selectedEmoji.isEmpty) {
//       // If no emoji is selected, show an error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please select an emoji before submitting."),
//           backgroundColor: Colors.black,
//         ),
//       );
//     } else {
//       // If emoji is selected, show thank you dialog
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Thank You"),
//           content: Text("Your Feedback means a lot to us.", ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>BN()));  // Close dialog
//                 //_resetForm();  // Reset form after submission
//               },
//               child: Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   // Method to reset the form after submission
//   // void _resetForm() {
//   //   setState(() {
//   //     _selectedEmoji = '';  // Reset selected emoji
//   //     _commentController.clear();  // Clear comment field
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeNotifier = Provider.of<ThemeNotifier>(context);
//     Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
//     Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
//     Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
//     return Scaffold(
//       appBar: AppBar(title: Text("Feedback", style: GoogleFonts.poppins(color: TextColor))),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("How was your experience?", style: GoogleFonts.poppins(color: TextColor)),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _emojiButton("😡", "Angry",),
//                 _emojiButton("😐", "Neutral"),
//                 _emojiButton("😊", "Happy"),
//                 _emojiButton("😍", "Loved it"),
//               ],
//             ),
//             SizedBox(height: 20),
//             Text(
//               _selectedEmoji.isEmpty ? "No feedback selected" : "You selected: $_selectedEmoji",
//               style: GoogleFonts.poppins(color: TextColor),
//             ),
//             SizedBox(height: 20),
//             Text("Leave a comment (optional):", style: GoogleFonts.poppins(color: TextColor)),
//             SizedBox(height: 20),
//             TextField(
//               controller: _commentController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Your feedback...",
//                 hintStyle: GoogleFonts.poppins(color: TextColor)
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitFeedback, style: ElevatedButton.styleFrom(backgroundColor: buttonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),minimumSize: const Size(200, 50)),
//               child: Text("Submit Feedback", style: GoogleFonts.poppins(color: TextColor)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }