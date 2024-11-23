import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                controller: _organizationController,
                decoration: InputDecoration(
                  labelText: 'Organization Name',
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  labelText: 'Birthday',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('MM/dd/yyyy').format(pickedDate);
                    setState(() {
                      _birthdayController.text = formattedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile Saved')),
                    );
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
