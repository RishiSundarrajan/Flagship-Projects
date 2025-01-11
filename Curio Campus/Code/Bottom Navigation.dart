import 'package:curio/Category%20Page.dart';
import 'package:curio/Profile%20Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Color format.dart';
import 'Front Page.dart';
import 'Search Page.dart';

class BN extends StatefulWidget {
  final String gname;
  final String gmail;
  final String photourl;
  final String loggedInPhone;
  const BN({super.key, required this.loggedInPhone, required this.gname, required this.gmail, required this.photourl, });

  @override
  State<BN> createState() => _BNState();
}
class _BNState extends State<BN> {
  int cindex=0;
  void tap(index){
    setState(() {
      cindex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      frontpage(gmail: widget.gmail, photourl: widget.photourl, loggedInPhone: widget.loggedInPhone, gname: widget.gname,),
      SP(loggedInPhone: widget.loggedInPhone,),
      CP(loggedInPhone: widget.loggedInPhone,),
      PP(loggedInPhone: widget.loggedInPhone, gname: widget.gname, gmail: widget.gmail, photourl: widget.photourl,)
    ];
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color TextColor = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color navBarBackgroundColor = themeNotifier.isDarkMode ? Colors.black : Colors.deepPurple;
    Color selectedIconColor = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    Color unselectedIconColor = themeNotifier.isDarkMode ? Colors.white : Colors.white;
    return Scaffold(
      body: pages[cindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navBarBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: unselectedIconColor),
            label: "Home",
            backgroundColor: navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: unselectedIconColor),
            label: "Search",
            backgroundColor: navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined, color: unselectedIconColor),
            label: "Category",
            backgroundColor: navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: unselectedIconColor),
            label: "Profile",
            backgroundColor: navBarBackgroundColor,),
        ],
        currentIndex: cindex,
        selectedItemColor: selectedIconColor,   // Color for the selected item
        unselectedItemColor: unselectedIconColor, // Color for the unselected items
        onTap: tap,
      ),
    );
  }
}
