import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageInternship extends StatelessWidget {
  Future<void> _updateApplicationStatus(
      String applicationId, String status) async {
    final applicationRef = FirebaseFirestore.instance.collection('Applications').doc(applicationId);

    if (status == 'Accepted') {
      // Move application to 'Accepted Interns' collection
      final applicationData = (await applicationRef.get()).data();
      if (applicationData != null) {
        await FirebaseFirestore.instance.collection('Accepted_Interns').add(applicationData);
      }
    }

    // Update the application status or delete the document
    if (status == 'Rejected') {
      await applicationRef.delete();
    } else {
      await applicationRef.update({'status': status});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Applications'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Applications').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final applications = snapshot.data!.docs;
          if (applications.isEmpty) {
            return Center(child: Text('No applications submitted yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final applicationId = application.id;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application['vacancyTitle'] ?? 'Vacancy Title',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text('Category: ${application['category']}'),
                      SizedBox(height: 10),
                      Text('Name: ${application['name']}'),
                      Text('Email: ${application['email']}'),
                      Text('Phone: ${application['phone']}'),
                      SizedBox(height: 10),
                      Text('Cover Letter: ${application['coverLetter']}'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _updateApplicationStatus(applicationId, 'Accepted');
                            },
                            child: Text('Accept', style: TextStyle(color: Colors.green)),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              _updateApplicationStatus(applicationId, 'Rejected');
                            },
                            child: Text('Reject', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
