import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageInternship extends StatelessWidget {
  final String employerId; // Assuming each employer has a unique ID

  ManageInternship({required this.employerId});

  Future<void> _updateApplicationStatus(
      String applicationId, String internshipId, String category, String status) async {
    final applicationRef = FirebaseFirestore.instance
        .collection('Internship_Posted')
        .doc(category)
        .collection('Opportunities')
        .doc(internshipId)
        .collection('Applications')
        .doc(applicationId);

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
        title: Text('Manage Internships'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Internship_Posted')
            .where('employerId', isEqualTo: employerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final internships = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: internships.length,
            itemBuilder: (context, index) {
              final internship = internships[index];
              final internshipId = internship.id;
              final category = internship['category'];
              return ExpansionTile(
                title: Text(
                  internship['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Status: ${internship['status'] ?? 'Active'}'),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Internship_Posted')
                        .doc(category)
                        .collection('Opportunities')
                        .doc(internshipId)
                        .collection('Applications')
                        .snapshots(),
                    builder: (context, applicationSnapshot) {
                      if (!applicationSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final applications = applicationSnapshot.data!.docs;
                      return Column(
                        children: applications.map((application) {
                          final applicationId = application.id;
                          return ListTile(
                            title: Text(application['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${application['email']}'),
                                Text('Phone: ${application['phone']}'),
                                Text('Cover Letter: ${application['coverLetter']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    _updateApplicationStatus(applicationId, internshipId, category, 'Accepted');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    _updateApplicationStatus(applicationId, internshipId, category, 'Rejected');
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
