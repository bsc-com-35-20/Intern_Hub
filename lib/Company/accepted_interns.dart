import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internhub/Home/UserDetails.dart'; 

class AcceptedInternsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Interns'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Accepted_Interns').snapshots(),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
           if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No accepted interns yet.'));
          }

          final acceptedInterns = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: acceptedInterns.length,
            itemBuilder: (context, index) {
              final intern = acceptedInterns[index];
              
              final internName = intern['name'] ?? 'No Name Provided';
              final internEmail = intern['email'] ?? 'No Email Provided';

               return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    internName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Email: $internEmail'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  onTap: () {
                    // Navigate to the User Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}