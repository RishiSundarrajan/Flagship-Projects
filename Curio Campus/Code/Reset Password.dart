import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';
import 'Login Page.dart';
import 'package:http/http.dart'as http;

class RP extends StatefulWidget {
  String mob;
   RP({super.key, required this.mob});

  @override
  State<RP> createState() => _RPState();
}

class _RPState extends State<RP> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();

  bool signIsPasswordVisible = false;
  bool signIsPasswordVisible1 = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      signIsPasswordVisible =! signIsPasswordVisible; //a = !a
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

  _validatePin(){
    setState(() {
      if(a.text != b.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entered password did not match')));
      }
      else{
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Congratulation!!", style: GoogleFonts.poppins(fontSize: 22)),
            content: Text("Your Pin Rested Successfully", style: GoogleFonts.poppins(fontSize: 15)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));
                },
                child: Text("OK", style: GoogleFonts.poppins(fontSize: 15)),
              ),
            ],
          ),
        );
      }
    }
    );
  }

  var RP = {};
  _fetchrestpin()async{
    final response = await http.post(Uri.parse("http://49.204.232.254:90/users/updatepassword"),
    headers: {"content-type": "application/json"},
      body: json.encode ({
        "phonenumber" : widget.mob,
        "newPassword": b.text,
      })
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201){
      setState(() {
        RP = json.decode(response.body);
        if(_validatePin()){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect Pin number')));
        }
      });
    } else{
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Kindly re-check the entered data')));
    };
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
              Align(alignment: Alignment.topCenter),
              Container(
                height: 450,
                width: 420,
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text("Reset Pin",style: GoogleFonts.poppins(color: TextColor, fontSize: 22)),
                      SizedBox(height: 10,),
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
                          controller: a,
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
                            temporarilyShowPassword(a, true);
                          },
                          onCompleted: (pin) {
                            a.text = pin;
                             // validatePasswords();
                            temporarilyShowPassword(a, true);
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
                         // validator: ,
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
                             // validatePasswords();
                            temporarilyShowPassword(b, true);
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: (){
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            isLoading = true;
                            _fetchrestpin().whenComplete(()=> setState(() {
                              isLoading = false;
                            }));
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('Entered password did not match', style: GoogleFonts.poppins(color: TextColor))));
                        };
                      }, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),minimumSize: const Size(300, 60),backgroundColor: bb), child: Text("Confirm Pin", style: GoogleFonts.poppins(color: ww))),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Remembered your password?", style: GoogleFonts.poppins(color: TextColor)),
                          GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LP()));},
                              child: Text(" Login",style: GoogleFonts.poppins(color: blbl)))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
