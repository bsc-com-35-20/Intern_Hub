import 'package:flutter/material.dart';

class InternshipAlerts extends StatelessWidget {
  const InternshipAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Alerts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Application Received'),
              subtitle: const Text('Get notified when a new application is submitted.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: const Text('Internship Completed'),
              subtitle: const Text('Get notified when an intern completes their internship.'),
              value: false,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: const Text('Feedback Received'),
              subtitle: const Text('Get notified when feedback is submitted by an intern.'),
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