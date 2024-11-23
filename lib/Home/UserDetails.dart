import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internhub/Home/ChangePasswordPage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _programController = TextEditingController();

  Map<String, dynamic>? userDetails;
  String? profileImageUrl;

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
            profileImageUrl = userDetails!['profileImageUrl'];
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }
Future<void> uploadProfileImage(File imageFile) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${user.uid}/profile_picture.png');
    
    await storageRef.putFile(imageFile);
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
          'profileImageUrl': profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        print('Error updating user details: $e');
      }
    }
  }

 Future<void> _pickAndUploadImage() async {
  User? user = _auth.currentUser;

  if (user != null) {
    try {
      // Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        // Web uses Uint8List instead of File
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        // Upload the image to Firebase Storage
        TaskSnapshot uploadTask = await _storage
            .ref('profile_images/${user.email}/$fileName')
            .putData(fileBytes!);

        // Get the download URL
        String downloadUrl = await uploadTask.ref.getDownloadURL();

        setState(() {
          profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile image.')),
      );
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
                    GestureDetector(
  onTap: _pickAndUploadImage,
  child: CircleAvatar(
    radius: 50,
    backgroundColor: Colors.grey[300],
    backgroundImage: profileImageUrl != null
        ? NetworkImage(profileImageUrl!)
        : null,
    child: profileImageUrl == null
        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[600])
        : null,
  ),
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
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
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
