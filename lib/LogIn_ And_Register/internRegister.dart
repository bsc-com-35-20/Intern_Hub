import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _skillsController = TextEditingController();

  String? _selectedGender;
  String? _selectedUniversity;
  File? _profileImage;
  String? _profileImageUrl;

  // List of universities
  final List<String> universities = [
    'University of Malawi',
    'Malawi University of Business and Applied Sciences',
    'Malawi University of Science and Technology',
    'MZUNI',
    'Lilongwe University of Agriculture and ',
    'Kamuzu University of Health and Environmental sciences'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print('Storage permission granted');
      // Proceed with accessing storage
    } else {
      print('Storage permission denied');
    }
  }

  Future<void> _uploadProfileImage(User user) async {
    if (_profileImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.email}.jpg');

      await storageRef.putFile(_profileImage!);
      _profileImageUrl = await storageRef.getDownloadURL();
    }
  }

  Future<void> _saveInternDetails(User user) async {
    try {
      // Save intern details in Firestore
      await FirebaseFirestore.instance
          .collection('Intern_Personal_Details')
          .doc(user.email)
          .set({
        'name': _nameController.text.trim(),
        'email': user.email,
        'age': _ageController.text.trim(),
        'gender': _selectedGender,
        'university': _selectedUniversity,
        'skills': _skillsController.text,
        'profileImageUrl': _profileImageUrl,
        'createdAt': Timestamp.now(),
      });

      // Navigate to Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            name: _nameController.text.trim(),
            email: user.email!,
            age: _ageController.text.trim(),
            skills: _skillsController.text,
            gender: _selectedGender!,
            university: _selectedUniversity!,
            profileImageUrl: _profileImageUrl,
          ),
        ),
      );
    } catch (e) {
      print('Error saving intern details: $e');
    }
  }

  Future<void> _registerIntern() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Upload profile image
        await _uploadProfileImage(userCredential.user!);

        // Save intern details
        await _saveInternDetails(userCredential.user!);

        Fluttertoast.showToast(
          msg: "Registered Successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.blue,
          fontSize: 16.0,
        );
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "Registration failed",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.red,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your age';
                      }
                      int? age = int.tryParse(value);
                      if (age == null || age < 18 || age > 50) {
                        return 'Enter a valid age (18-50)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Gender'),
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedGender = value),
                    validator: (value) =>
                        value == null ? 'Select your gender' : null,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'University'),
                    value: _selectedUniversity,
                    items: universities.map((university) {
                      return DropdownMenuItem(
                          value: university, child: Text(university));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedUniversity = value),
                    validator: (value) =>
                        value == null ? 'Select your university' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your email' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value == null || value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) =>
                        value != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _registerIntern,
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String age;
  final String gender;
  final String university;
  final String? profileImageUrl;

  ProfilePage({
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.university,
    this.profileImageUrl, 
    required String skills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 20),
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Age: $age'),
            Text('Gender: $gender'),
            Text('University: $university'),
          ],
        ),
      ),
    );
  }
}
