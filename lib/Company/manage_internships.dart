import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageInternship extends StatelessWidget {
  Future<void> _updateApplicationStatus(String applicationId, String status) async {
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
                          // Tap to view more details
                          IconButton(
                            icon: Icon(Icons.visibility, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicationDetailsPage(applicationId: applicationId),
                                ),
                              );
                            },
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

class ApplicationDetailsPage extends StatelessWidget {
  final String applicationId;

  ApplicationDetailsPage({required this.applicationId});

  Future<DocumentSnapshot> _getApplicationDetails() async {
    return await FirebaseFirestore.instance.collection('Applications').doc(applicationId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Details'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getApplicationDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final application = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application['vacancyTitle'] ?? 'Vacancy Title',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Category: ${application['category']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Name: ${application['name']}', style: TextStyle(fontSize: 18)),
                Text('Email: ${application['email']}', style: TextStyle(fontSize: 18)),
                Text('Phone: ${application['phone']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 15),
                Text('Cover Letter:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(application['coverLetter'] ?? 'No cover letter provided', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                      child: Text('Back', style: TextStyle(color: Colors.teal)),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        _updateApplicationStatus(application.id, 'Accepted');
                      },
                      child: Text('Accept', style: TextStyle(color: Colors.green)),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        _updateApplicationStatus(application.id, 'Rejected');
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

  Future<void> _updateApplicationStatus(String applicationId, String status) async {
    final applicationRef = FirebaseFirestore.instance.collection('Applications').doc(applicationId);

    if (status == 'Accepted') {
      final applicationData = (await applicationRef.get()).data();
      if (applicationData != null) {
        await FirebaseFirestore.instance.collection('Accepted_Interns').add(applicationData);
      }
    }

    if (status == 'Rejected') {
      await applicationRef.delete();
    } else {
      await applicationRef.update({'status': status});
    }
  }
}
