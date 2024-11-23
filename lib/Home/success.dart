import 'package:flutter/material.dart';
import 'package:internhub/Home/HomePage.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 4, 171, 151),
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Application Submitted Successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Your application is pending review. Applications that pass the initial review will be contacted at a later date, as outlined during the submission process.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 4, 171, 151),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 4, 171, 151), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
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
