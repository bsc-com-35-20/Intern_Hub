import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageInternship extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchApplications(
      String internshipId, String category) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Internship_Posted')
        .doc(category)
        .collection('Opportunities')
        .doc(internshipId)
        .collection('Applications')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  void showApplications(
      BuildContext context, String internshipId, String category) async {
    final applications = await fetchApplications(internshipId, category);

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index];
          return ListTile(
            title: Text(application['name']),
            subtitle: Text(
                'Email: ${application['email']}\nPhone: ${application['phone']}'),
            onTap: () {
              // Additional actions or details can go here
            },
          );
        },
      ),
    );
  }

  Widget _buildInternshipCard(String title, String status, String internshipId,
      String category, BuildContext context) {
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
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text('Status: $status'),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          showApplications(context, internshipId, category);
        },
      ),
    );
  }

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
            // Replace with dynamic data fetching
            _buildInternshipCard('Software Development Intern', 'In Progress',
                'internshipId1', 'Software', context),
            _buildInternshipCard('Marketing Intern', 'Completed',
                'internshipId2', 'Marketing', context),
            _buildInternshipCard('Data Science Intern', 'In Progress',
                'internshipId3', 'Data Science', context),
          ],
        ),
      ),
    );
  }
}
