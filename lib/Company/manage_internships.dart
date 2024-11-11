import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ManageInternship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Internships'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Active Internships',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInternshipCard('Software Development Intern', 'In Progress', context),
            _buildInternshipCard('Marketing Intern', 'Completed', context),
            _buildInternshipCard('Data Science Intern', 'In Progress', context),
          ],
        ),
      ),
    );
  }
Widget _buildInternshipCard(String title, String status, BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.work_outline, color: Colors.teal, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text('Status: $status'),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          // Navigate to more details about the internship
        },
      ),
    );
  }
}
