import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internhub/Home/ChangePasswordPage.dart';
class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _programController = TextEditingController();

  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot snapshot = await _firestore
            .collection('Intern_Personal_Details')
            .doc(user.email)
            .get();

        if (snapshot.exists) {
          setState(() {
            userDetails = snapshot.data() as Map<String, dynamic>?;

            _phoneController.text = userDetails!['phone'] ?? '';
            _universityController.text = userDetails!['university'] ?? '';
            _programController.text = userDetails!['course'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('Intern_Personal_Details').doc(user.email).update({
          'phone': _phoneController.text,
          'university': _universityController.text,
          'course': _programController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        print('Error updating user details: $e');
      }
    }
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: userDetails == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              _buildProfileField('Name', userDetails!['name']),
              _buildProfileField('Email', userDetails!['email']),
              _buildEditableField('Phone', _phoneController),
              _buildEditableField('University', _universityController),
              _buildEditableField('Program', _programController),
              SizedBox(height: 20),
              _buildStyledButton('Save Changes', _updateUserDetails),
              SizedBox(height: 10),
              _buildStyledButton('Change Password', _navigateToChangePassword),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        textStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title),
    );
  }

  Widget _buildProfileField(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 6)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 6)],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
