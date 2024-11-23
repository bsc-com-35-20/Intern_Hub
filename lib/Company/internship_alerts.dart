import 'package:flutter/material.dart';

class InternshipAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Alerts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Application Received'),
              subtitle: Text('Get notified when a new application is submitted.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Internship Completed'),
              subtitle: Text('Get notified when an intern completes their internship.'),
              value: false,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Feedback Received'),
              subtitle: Text('Get notified when feedback is submitted by an intern.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}