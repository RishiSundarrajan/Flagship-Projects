import 'package:balloon_widget/balloon_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuisinemate/Front%20Page.dart';
import 'package:cuisinemate/Instruction.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IP extends StatefulWidget {
  const IP({super.key});
  @override
  State<IP> createState() => _IPState();
}

class _IPState extends State<IP> {
  bool showBalloon = false;
  List a = [
    "Assets/3.jpg",
    "Assets/2.jpg",
  ];
  int currentindex=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              showBalloon = !showBalloon;
            });
          }, icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.info_outline, size: 30,),
          ))
        ],
      ),
      body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(alignment: Alignment.center),
                SizedBox(height: 20,),
                Text("C U I S I N E M A T E", style: GoogleFonts.poppins(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700)),
                SizedBox(height: 20,),
                Container(
                  height: 500,
                  width: 400,
                  child: CarouselSlider.builder(
                    itemCount: a.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        height: 500,
                        width: 412,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: AssetImage(a[index]), fit: BoxFit.fill)),
                      );
                    },
                    options: CarouselOptions(
                        height: 500,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentindex = index;
                          });
                        }),
                  ),
                ),
                SizedBox(height: 30),
                DotsIndicator(
                  dotsCount: a.length,
                  position: currentindex,
                ),
                SizedBox(height: 55,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => FP()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            minimumSize: const Size(130, 60)),
                        child: Text("Front Page", style: GoogleFonts.poppins(color: Colors.white),
                        )),
                    Text("   OR   ", style: GoogleFonts.poppins(color: Colors.black)
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => IN()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            minimumSize: const Size(130, 60)),
                        child: Text("Instruction", style: GoogleFonts.poppins(color: Colors.white))),
                  ],
                ),
              ],
            ),
            if (showBalloon)
              Positioned(
                top: kToolbarHeight - 50, // Positioned just below the AppBar
                right: 12,
                child: Material(
                  child: Balloon(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    nipPosition: BalloonNipPosition.topRight,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    nipSize: 12,
                    nipMargin: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('CuisineMate Welcomes You', style: GoogleFonts.poppins(color: Colors.white) // Adjusted color for better contrast
                      ),
                    ),
                  ),
                ),
              ),
          ]
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}