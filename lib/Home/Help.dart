import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.blueAccent, // Changed to teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHelpSection('Getting Started', 'Learn how to create an account and navigate through the app.'),
            _buildHelpSection('How to Find Internships', 'Tips and steps to search for internships effectively.'),
            _buildHelpSection('Updating Your Profile', 'Instructions on how to edit your profile and keep it updated.'),
            _buildHelpSection('Contacting Support', 'Get information on how to reach our support team for assistance.'),
            _buildHelpSection('Frequently Asked Questions', 'Common questions and answers that can help you.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action for feedback or support request
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Changed to teal
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Changed to teal
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]), // Softer text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
