import 'package:curio/Login%20Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';
import 'Reset Password.dart';

class FP extends StatefulWidget {
  const FP({super.key});

  @override
  State<FP> createState() => _FPState();
}

class _FPState extends State<FP> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController a = TextEditingController();
  String otp = "";
  String mob = "";

  bool isPhoneVerified = false;
  bool isPhonenoenable = true;
  bool isLoading = false;

  var OTP = {};
  _otp()async{
    final response = await http.post(Uri.parse("http://92.205.109.210:8028/mobileauth/send-otp-sms"),
        headers: {"content-type": "application/json"},
        body: json.encode({
          "number": a.text,
          "appname": "Curio Campus"
        })
    );
    _showOtpBottomSheet(context);
    if (response.statusCode == 200 || response.statusCode == 201);
    setState(() {
      OTP = json.decode(response.body);
      print(OTP);
      mob = a.text;
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
                Text('Enter OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 20),
                Text(
                  'An OTP has been sent to ${a.text}. Please enter it below:', style: GoogleFonts.poppins(fontSize: 15),
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
          "number": a.text,
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
          content: Text("OTP is verified", style: GoogleFonts.poppins(fontSize: 17)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RP(mob: mob,)));
              },
              child: Text("OK", style: GoogleFonts.poppins(fontSize: 15)),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error", style: GoogleFonts.poppins(fontSize: 23)),
          content: Text("Invalid OTP", style: GoogleFonts.poppins(fontSize: 15)),
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
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color bb = themeNotifier.isDarkMode ? Colors.black : Colors.black;
    Color blbl = themeNotifier.isDarkMode ? Colors.blue : Colors.blue;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(alignment: Alignment.topCenter,),
              Card(
                elevation: 10,
                color: Colors.white,
                child: Container(
                  height: 400,
                  width: 380,
                  decoration: BoxDecoration(
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Text("Forgot Password", style: GoogleFonts.poppins(color: TextColor, fontSize: 20)),
                      SizedBox(height: 25),
                      Container(
                        height: 80,
                        width: 350,
                        child: TextFormField(
                          enabled: isPhonenoenable,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: a,
                          validator: (input) {
                            if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input!)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                          decoration: InputDecoration(
                            prefix: Text("+91"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                              //border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.phone_in_talk),
                              hintText: "Phone number",
                              hintStyle: GoogleFonts.poppins(color: TextColor),
                              labelText: "Phone number",
                              labelStyle: GoogleFonts.poppins(color: TextColor)
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            isLoading = true;
                            _otp().whenComplete(()=> setState(() {
                              isLoading = false;
                            }));
                          });
                        }else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error", style: GoogleFonts.poppins(color: TextColor, fontSize: 22)),
                                content: Text("Please enter a valid phone number", style: GoogleFonts.poppins(color: TextColor, fontSize: 15)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK", style: GoogleFonts.poppins(color: TextColor, fontSize: 15)),
                                  ),
                                ],
                              ));
                        }
                      }, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),minimumSize: const Size(300, 60),backgroundColor: Colors.black), child: Text("Send OTP", style: TextStyle(color: Colors.white),)),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Remembered your password?", style: GoogleFonts.poppins(color: TextColor)),
                          GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));},
                              child: Text(" Login", style: GoogleFonts.poppins(color: blbl)))
                        ],
                      )
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
}
