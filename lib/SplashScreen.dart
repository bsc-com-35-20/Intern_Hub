import 'package:flutter/material.dart';
import 'package:internhub/LogIn_%20And_Register/Log_In.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular logo
            CircularLogo(),
            SizedBox(height: 30),
            // Tagline
            TaglineText(),
            SizedBox(height: 20),
            // CTA button
            CallToActionButton(),
          ],
        ),
      ),
    );
  }
}

class CircularLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF6C63FF), width: 8),
      ),
      child: Center(
        child: Text(
          "InternHub",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class TaglineText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Find Your\nDream Job",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class CallToActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Log_In()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6C63FF),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        "Lets begin",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
