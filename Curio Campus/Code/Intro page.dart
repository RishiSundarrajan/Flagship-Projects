import 'package:carousel_slider/carousel_slider.dart';
import 'package:curio/Login%20Page.dart';
import 'package:curio/Sign%20up.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:balloon_widget/balloon_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';

class IP extends StatefulWidget {
  const IP({super.key});
  @override
  State<IP> createState() => _IPState();
}
class _IPState extends State<IP> {
  bool showBalloon = false;
  List a = [
    "Assets/1.jpg",
    "Assets/2.jpg",
    "Assets/3.jpg",
    "Assets/4.jpg",
    "Assets/5.jpg",
    "Assets/6.jpg",
  ];
  int currentindex=0;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color buttonColor = themeNotifier.isDarkMode ? Colors.grey : Colors.black;
    return Scaffold(
      appBar: AppBar(
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
            Text("Curio", style: GoogleFonts.poppins(color: TextColor)),
            Text("Campus", style: GoogleFonts.poppins(color: TextColor)),
            SizedBox(height: 15,),
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
                          MaterialPageRoute(builder: (context) => LP()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minimumSize: const Size(130, 60)),
                    child: Text("Login", style: GoogleFonts.poppins(color: TextColor),
                    )),
                Text("   OR   ", style: GoogleFonts.poppins(color: TextColor)
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signup()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minimumSize: const Size(130, 60)),
                    child: Text("Sign up", style: GoogleFonts.poppins(color: TextColor))),
              ],
            ),
          ],
        ),
            if (showBalloon)
              Positioned(
                top: kToolbarHeight - 50, // Positioned just below the AppBar
                right: 12,
                child: Material(
                  //color: Colors.red, // Ensure the balloon overlay is transparent except the balloon
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
                      child: Text('Curio Campus Welcomes You', style: GoogleFonts.poppins(color: TextColor) // Adjusted color for better contrast
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