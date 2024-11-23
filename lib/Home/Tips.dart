import 'package:flutter/material.dart';
import 'package:internhub/Home/InternshipTips.dart'; // Import your InternshipTips page
import 'package:internhub/Home/NetworkingOpportunities.dart'; // Import your NetworkingOpportunities page

class TipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tips"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the page with teal color
            Text(
              "Choose a tip category:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Set the text color to teal
              ),
            ),
            SizedBox(height: 20),

            // ListView for displaying the options
            Expanded(
              child: ListView(
                children: [
                  // List Tile for Internship Tips
                  ListTile(
                    onTap: () {
                      // Navigate to Internship Tips page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InternshipTips()),
                      );
                    },
                    title: Text("Internship Tips"),
                    trailing: Icon(Icons.arrow_forward),
                  ),

                  // List Tile for Networking Tips
                  ListTile(
                    onTap: () {
                      // Navigate to Networking Opportunities page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NetworkingOpportunities()),
                      );
                    },
                    title: Text("Networking Tips"),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
