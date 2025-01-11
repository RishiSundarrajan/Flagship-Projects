import 'package:flutter/material.dart';

class ComingSoonPage extends StatefulWidget {
  @override
  _ComingSoonPageState createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 27),
              Center(
                child: Text(
                  'We Are Working On It!',
                  style: TextStyle(fontSize: 34),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'This feature is coming soon. Stay tuned!',
                  style: TextStyle(fontSize: 17),

                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
