// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostInternshipScreen extends StatefulWidget {
  const PostInternshipScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostInternshipScreenState createState() => _PostInternshipScreenState();
}

class _PostInternshipScreenState extends State<PostInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _requirementsController.dispose();
    _responsibilitiesController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the current user's ID
        final userId = FirebaseAuth.instance.currentUser?.uid;

        // Check if the user is logged in
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not logged in')),
          );
          return;
        }

        // Create a new document in the 'internships' collection
        await FirebaseFirestore.instance.collection('internships').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'company': _companyController.text,
          'location': _locationController.text,
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
          'requirements': _requirementsController.text,
          'responsibilities': _responsibilitiesController.text,
          'contact': _contactController.text,
          'postedBy': userId,
        });

        // Clear the form fields after successful submission
        _titleController.clear();
        _descriptionController.clear();
        _companyController.clear();
        _locationController.clear();
        _startDateController.clear();
        _endDateController.clear();
        _requirementsController.clear();
        _responsibilitiesController.clear();
        _contactController.clear();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Internship posted successfully')),
        );
      } catch (error) {
        // Handle any errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post internship: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Internship'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _requirementsController,
                decoration: InputDecoration(labelText: 'Requirements'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the requirements';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _responsibilitiesController,
                decoration: InputDecoration(labelText: 'Responsibilities'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the responsibilities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact Information'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Post Internship'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
