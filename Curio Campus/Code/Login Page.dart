import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:curio/Bottom%20Navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Color format.dart';
import 'Forgot Password.dart';
import 'Sign up.dart';
import 'package:http/http.dart'as http;

class LP extends StatefulWidget {
  const LP({super.key});

  @override
  State<LP> createState() => _LPState();
}

class _LPState extends State<LP> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();

  bool signIsPasswordVisible = false;
  bool signIsPasswordVisible1 = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      signIsPasswordVisible =! signIsPasswordVisible;
    });
  }
  void temporarilyShowPassword(TextEditingController controller, bool isPassword) {
    if (controller.text.isNotEmpty) {
      setState(() {
        if (isPassword) {
          signIsPasswordVisible = true;
        } else {
          signIsPasswordVisible1 = true;
        }
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          if (isPassword) {
            signIsPasswordVisible = false;
          } else {
            signIsPasswordVisible1 = false;
          }
        });
      });
    }
  }
  var GUN = {};
  _fetchdata() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(Uri.parse("http://49.204.232.254:90/users/login"),
        headers: {"content-type": "application/json"},
        body: json.encode({
          "phonenumber": a.text,
          "password": b.text,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        GUN = json.decode(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BN(loggedInPhone: a.text, gmail: '', photourl: '', gname: '',),
          ),
        );
      } else {
        _showErrorDialog("Invalid Credential", "Kindly check your user credentials");
      }
    } catch (error) {
      _showErrorDialog("Error", "Something went wrong, please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 25)),
        content: Text(content, style: GoogleFonts.poppins(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK", style: GoogleFonts.poppins(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  String gname = "";
  String gmail = "";
  String photourl = "";

  // Sign in with Google function
  signInWithGoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return; // Sign-In Cancelled
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      if (user != null) {
        setState(() {
          gname = user.displayName ?? "No Name";
          gmail = user.email ?? "No Email";
          photourl = user.photoURL ?? "";
        });

        // Navigate to phone verification page
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => phoneauth(
              gname: gname,
              gmail: gmail,
              photourl: photourl,
            ),
          ),
        );
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      _showErrorDialog("Google Sign-In Failed", "Unable to fetch user details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color bb = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color blbl = themeNotifier.isDarkMode ? Colors.blue : Colors.blue;
    Color ww = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color TextColor = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      progressIndicator: SpinKitCircle(
        size: 50,
        color: Colors.blue,
      ),
      child: Scaffold(
        body: Form(key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 145),
                Align(),
                Container(
                  height: 90, width: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("Assets/CurioCampus.png"))
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Container(
                    height: 440,
                    width: 400,
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        Container(
                          height: 75,
                          width: 386,
                          child: TextFormField(
                            controller: a,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            validator: (input) {
                              if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input!)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefix: Text("+91"),
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.call),
                              border: OutlineInputBorder(borderSide: BorderSide()),
                              hintText: "Phone Number",
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Phone Number",
                              labelStyle: GoogleFonts.poppins(color: TextColor)
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Enter Pin", style: GoogleFonts.poppins(color: TextColor, fontSize: 16)),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Pinput(
                            length: 6,
                            controller: b,
                            obscureText: !signIsPasswordVisible,
                            obscuringCharacter: '*',
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            defaultPinTheme: PinTheme(
                              width: 69,
                              height: 56,
                              textStyle: TextStyle(
                                fontSize: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 36,
                              height: 36,
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onChanged: (pin) {
                              if (pin.length == 6) {
                                // validatePasswords();
                              }
                              temporarilyShowPassword(b, true);
                            },
                            onCompleted: (pin) {
                              b.text = pin;
                              //  validatePasswords();
                              temporarilyShowPassword(b, true);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 220.0),
                          child: GestureDetector(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FP()));
                          },child: Text("Forgot Password?", style: GoogleFonts.poppins(color: blbl))),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              isLoading = true;
                              _fetchdata().whenComplete(()=> setState(() {
                                isLoading = false;
                              }));
                            });
                          }
                        },style: ElevatedButton.styleFrom(backgroundColor: bb, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),minimumSize: const Size(290, 50)), child: Text("Login",style: GoogleFonts.poppins(color: ww))),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: GoogleFonts.poppins(color: TextColor)),
                            GestureDetector(onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>signup()));
                            },child: Text(" Sign Up", style: GoogleFonts.poppins(color: blbl))),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(text: "Or ", style: GoogleFonts.poppins(color: TextColor),
                            children: [
                              TextSpan(
                                text: "With", style: GoogleFonts.poppins(color: TextColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(onTap: (){
                          signInWithGoogle(context);
                        },
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 50,),
                                Image.network("https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                                  height: 50, // Adjust the size of the icon
                                  width: 50, // Adjust the size of the icon
                                ),
                                Text("Sign in with Google", style: GoogleFonts.poppins(color: TextColor)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class phoneauth extends StatefulWidget {
  final String gname;
  final String gmail;
  final String photourl;
  const phoneauth({super.key, required this.gname, required this.gmail, required this.photourl});

  @override
  State<phoneauth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<phoneauth> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  String otp = "";
  bool isPhoneVerified = false;
  bool isPhonenoenable = true;
  bool isLoading = false;
  var OTP = {};

  // Send OTP
  Future<void> _sendOtp() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    final response = await http.post(
      Uri.parse("http://92.205.109.210:8028/mobileauth/send-otp-sms"),
      headers: {"content-type": "application/json"},
      body: json.encode({"number": phoneController.text, "appname": "Curio Campus"}),
    );
    setState(() {
      isLoading = false; // Hide loading indicator
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        OTP = json.decode(response.body);
      });
      _showOtpBottomSheet(context);
    }
  }
  // Show OTP Bottom Sheet
  void _showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter OTP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 20),
                Text(
                  'An OTP has been sent to ${phoneController.text}. Please enter it below:',
                  style: GoogleFonts.poppins(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) {
                    setState(() {
                      otp = pin;
                    });
                    _verifyOtp();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Verify OTP and Store Phone Number
  Future<void> _verifyOtp() async {
    final response = await http.post(
      Uri.parse("http://92.205.109.210:8028/mobileauth/verify-otp-sms"),
      headers: {"content-type": "application/json"},
      body: jsonEncode({"number": phoneController.text, "otp": otp}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isPhoneVerified = true;
        isPhonenoenable = false;
      });
      await _storePhoneNumber();
      _showSuccessDialog();
    } else {
      _showInvalidOtpDialog();
    }
  }

  // Store Phone Number
  Future<void> _storePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("loggedInPhone", phoneController.text);
  }
  // Success Dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Authenticated", style: GoogleFonts.poppins(fontSize: 25)),
        content: Text("OTP is verified", style: GoogleFonts.poppins(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BN(
                    loggedInPhone: phoneController.text,
                    gmail: widget.gmail,
                    photourl: widget.photourl,
                    gname: widget.gname,
                  ),
                ),
              );
            },
            child: Text("OK", style: GoogleFonts.poppins(fontSize: 14)),
          ),
        ],
      ),
    );
  }
  // Invalid OTP Dialog
  void _showInvalidOtpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error", style: GoogleFonts.poppins(fontSize: 25)),
        content: Text("Invalid OTP", style: GoogleFonts.poppins(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK", style: GoogleFonts.poppins(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color textColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(color: Colors.blue),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(alignment: Alignment.topCenter,),
              Card(
                elevation: 10,
                color: Colors.white,
                child: Container(
                  height: 400,
                  width: 380,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text("Enter Your Phone Number", style: GoogleFonts.poppins(color: textColor, fontSize: 20)),
                      SizedBox(height: 25),
                      Container(
                        height: 80,
                        width: 350,
                        child: TextFormField(
                          enabled: isPhonenoenable,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: phoneController,
                          validator: (input) {
                            if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input!)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                          decoration: InputDecoration(
                            prefix: Text("+91"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                            prefixIcon: Icon(Icons.phone_in_talk),
                            hintText: "Phone number",
                            hintStyle: GoogleFonts.poppins(color: textColor),
                            labelText: "Phone number",
                            labelStyle: GoogleFonts.poppins(color: textColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              _sendOtp().whenComplete(() => setState(() => isLoading = false));
                            });
                          } else {
                            _showInvalidPhoneNumberDialog();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          minimumSize: const Size(300, 60),
                          backgroundColor: Colors.black,
                        ),
                        child: Text("Verify", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Invalid Phone Number Dialog
  void _showInvalidPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error", style: GoogleFonts.poppins(fontSize: 22)),
        content: Text("Please enter a valid phone number", style: GoogleFonts.poppins(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK", style: GoogleFonts.poppins(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

///
// var GUN = {};
// _fetchdata() async{
//   final response=await http.post(Uri.parse("http://49.204.232.254:90/users/login"),
//   headers: {"content-type" : "application/json"},
//     body: json.encode({
//       "phonenumber": a.text,
//       "password": b.text
//     })
//   );
//   print(response.statusCode);
//   if(response.statusCode == 200 || response.statusCode == 201){
//     print("Logged in with phone: ${a.text}"); // Debug: Print the phone number being logged in
//     setState(() {
//       GUN = json.decode(response.body);
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>BN(loggedInPhone: a.text)));
//     });
//   }else{
//     showDialog(context: context, builder: (context) => AlertDialog(
//         title: Text("Invalid Credential", style: GoogleFonts.poppins(fontSize: 25)),
//         content: Text("Kindly check your user credentials", style: GoogleFonts.poppins(fontSize: 20)),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("OK", style: GoogleFonts.poppins(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }
// }