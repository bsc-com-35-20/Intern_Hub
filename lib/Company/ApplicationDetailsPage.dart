import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationDetailPage extends StatelessWidget {
  final String applicationId;

  ApplicationDetailPage({required this.applicationId});

  Future<Map<String, dynamic>?> _fetchApplicationDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Applications').doc(applicationId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching application details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Details'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchApplicationDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final applicationData = snapshot.data;
          if (applicationData == null) {
            return Center(child: Text('Application not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vacancy Title: ${applicationData['vacancyTitle'] ?? 'N/A'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Category: ${applicationData['category'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Name: ${applicationData['name'] ?? 'N/A'}'),
                Text('Email: ${applicationData['email'] ?? 'N/A'}'),
                Text('Phone: ${applicationData['phone'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Cover Letter: ${applicationData['coverLetter'] ?? 'N/A'}'),
                
                Text('Referral: ${applicationData['referral']?? 'N/A'}'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Accept application logic
                        // _updateApplicationStatus(applicationId, 'Accepted');
                      },
                      child: Text('Accept', style: TextStyle(color: Colors.green)),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        // Reject application logic
                        // _updateApplicationStatus(applicationId, 'Rejected');
                      },
                      child: Text('Reject', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}