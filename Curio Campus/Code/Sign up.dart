import 'dart:async';
import 'dart:convert';
import 'package:curio/Login%20Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'Color format.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  TextEditingController c = TextEditingController();
  TextEditingController d = TextEditingController();
  TextEditingController e = TextEditingController();
  String otp = "";

  bool signIsPasswordVisible = false;
  bool signIsPasswordVisible1 = false;
  bool isPhoneVerified = false;
  bool isPhonenoenable = true;
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
  var OTP = {};
  _otp()async{
    final response = await http.post(Uri.parse("http://92.205.109.210:8028/mobileauth/send-otp-sms"),
        headers: {"content-type": "application/json"},
        body: json.encode({
          "number": c.text,
          "appname": "Curio Campus"
        })
    );
    print(response.statusCode);
    _showOtpBottomSheet(context);
    if (response.statusCode == 200 || response.statusCode == 201);
    setState(() {
      OTP = json.decode(response.body);
    });
  }
  void _showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter OTP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 20),
                Text(
                  'An OTP has been sent to ${c.text}. Please enter it below:', style: GoogleFonts.poppins(fontSize: 15),
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
                    print("Entered OTP: $pin");
                    _verifyotp();
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
  var sample2 = {};
  _verifyotp() async {
    final response = await http.post(Uri.parse("http://92.205.109.210:8028/mobileauth/verify-otp-sms"),
        headers: {
          "content-type": "application/json"
        },
        body: jsonEncode({
          "number": c.text,
          "otp": otp,
        })
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        sample2 = json.decode(response.body);
        isPhoneVerified = true;
        isPhonenoenable = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Authenticated", style: GoogleFonts.poppins(fontSize: 25)),
          content: Text("OTP is verified", style: GoogleFonts.poppins(fontSize: 20)),
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
    } else {
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
  }
  _validatePin(){
    setState(() {
      if (d.text != e.text){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Entered pin is incorrect"))
        );
      }else{
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Hoorayyy!!", style: GoogleFonts.poppins(fontSize: 25)),
            content: Text("User Credentials Successfully Created", style: GoogleFonts.poppins(fontSize: 20)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));
                },
                child: Text("OK", style: GoogleFonts.poppins(fontSize: 14)),
              ),
            ],
          ),
        );
      }
    });
  }
  var create = {};
  _fetchdatasignup () async{
    final response = await http.post(Uri.parse("http://49.204.232.254:90/users/create"),
        headers: {"content-type": "application/json"},
        body: json.encode({
          "username": a.text,
          "email": b.text,
          "password": d.text,
          "confirmpassword": e.text,
          "phonenumber": c.text
        })
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201){
      setState(() {
        create = json.decode(response.body);
        if(isPhoneVerified){
          _validatePin();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kindly verify the phone number')),
          );
        }
      });
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kindly re-check the entered data')),
      );
    };
  }
  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }///key

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color bb = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color ww = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    Color border = themeNotifier.isDarkMode ? Colors.white : Colors.black;
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.5,
      progressIndicator: SpinKitCircle(
        size: 50,
        color: Colors.blue,
      ),
      child: Scaffold(
        body: Form(key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 9,
                  color: Colors.white,
                  child: Container(
                    height: 500,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Align(),
                        Container(
                          height: 80,
                          width: 410,
                          child: TextFormField(
                            controller: a,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            //inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(10)],
                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(15),FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                            validator: (value) {
                              // Regular expression that matches only letters (no numbers or special characters)
                              final RegExp usernameRegExp = RegExp(r'^[A-Za-z]+$');
                              if (value == null || value.isEmpty) {
                                return 'Username cannot be empty';
                              } else if (!usernameRegExp.hasMatch(value)) {
                                return 'Username must contain only letters';
                              }
                              return null; // Return null if the input is valid
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                              //border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Username",
                              labelStyle: GoogleFonts.poppins(color: TextColor)
                            ),
                          ),
                        ),
                        SizedBox(height: 7,),
                        Container(
                          height: 80,
                          width: 410,
                          decoration: BoxDecoration(
                            // border: Border.all(width: .1),
                          ),
                          child: TextFormField(
                            controller: b,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                              //border: InputBorder.none,
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Email",
                              labelStyle: GoogleFonts.poppins(color: TextColor)
                            ),
                          ),
                        ),
                        SizedBox(height: 7,),
                        Container(
                          height: 80,
                          width: 410,
                          child: TextFormField(
                            enabled: isPhonenoenable,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: c,
                            validator: (input) {
                              if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input!)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                                prefix: Text("+91"),
                                //border: InputBorder.none,
                                prefixIcon: Icon(Icons.phone_in_talk),
                                hintText: "Phone number",
                                hintStyle: GoogleFonts.poppins(color: TextColor),
                                labelText: "Phone number",
                                labelStyle: GoogleFonts.poppins(color: TextColor),
                                suffixIcon: isPhoneVerified
                                    ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Verified", style: GoogleFonts.poppins(color: Colors.green,fontSize: 17,fontWeight: FontWeight.bold),),
                                )
                                    : TextButton(
                                  child: Text("Verify",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),),
                                  onPressed: () {
                                    if (c.text.isNotEmpty) {
                                      _otp();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Error", style: GoogleFonts.poppins(color: TextColor)),
                                            content: Text("Please enter a phone number", style: GoogleFonts.poppins(color: TextColor)),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK", style: GoogleFonts.poppins(color: TextColor)),
                                              ),
                                            ],
                                          ));
                                    }
                                  },
                                )
                            ),
                          ),
                        ),
                        Visibility(visible: isPhoneVerified,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Create Pin", style: GoogleFonts.poppins(color: TextColor, fontSize: 16)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Pinput(
                                  length: 6,
                                  controller: d,
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
                                    temporarilyShowPassword(d, true);
                                  },
                                  onCompleted: (pin) {
                                    d.text = pin;
                                    //  validatePasswords();
                                    temporarilyShowPassword(d, true);
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Confirm Pin", style: GoogleFonts.poppins(color: TextColor, fontSize: 16)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Pinput(
                                  length: 6,
                                  controller: e,
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
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onChanged: (pin) {
                                    if (pin.length == 6) {
                                      // validatePasswords();
                                    }
                                    temporarilyShowPassword(e, true);
                                  },
                                  onCompleted: (pin) {
                                    e.text = pin;
                                    //  validatePasswords();
                                    temporarilyShowPassword(e, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    isLoading = true;
                    _fetchdatasignup().whenComplete(()=> setState(() {
                      isLoading = false;
                    }));
                  });
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kindly fill all the fields with appropriate data', style: GoogleFonts.poppins(color: TextColor))),
                  );
                };
              },style: ElevatedButton.styleFrom(backgroundColor: bb, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),minimumSize: const Size(230, 60),), child: Text("Sign Up", style: GoogleFonts.poppins(color: ww)))
            ],
          ),
        ),
      ),
    );
  }
}

