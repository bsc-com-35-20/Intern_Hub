import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internhub/Company/EmployersDashBoard.dart';

class PostInternship extends StatefulWidget {
  @override
  _PostInternshipState createState() => _PostInternshipState();
}

class _PostInternshipState extends State<PostInternship> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? _internshipTitle;
  String? _internshipDescription;
  String? _requirements;
  String? _location;
  String? _duration;
  String? _stipend;
  String? _category;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print("PostInternship screen loaded");
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Internship Opportunity'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach form key to Form widget
          child: ListView(
            children: [
              Text(
                'Post New Internship',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              
              SizedBox(height: 20),
              _buildTextField('Internship Title', false, (value) {
                _internshipTitle = value;
              }),
              SizedBox(height: 16),
              _buildTextField('Internship Description', true, (value) {
                _internshipDescription = value;
              }),
              SizedBox(height: 16),
              _buildTextField('Requirements', true, (value) {
                _requirements = value;
              }),
              SizedBox(height: 16),
              _buildTextField('Location', false, (value) {
                _location = value;
              }),
              SizedBox(height: 16),
              _buildTextField('Duration (e.g., 3 months)', false, (value) {
                _duration = value;
              }),
              SizedBox(height: 16),
              _buildTextField('Salary (if applicable)', false, (value) {
                _stipend = value;
              }),
              SizedBox(height: 16),
              _buildDropdown((value) {
                _category = value;
              }),
              SizedBox(height: 24),
              _buildPostButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // TextField Builder with Validator
  Widget _buildTextField(String label, bool isMultiline, Function(String?) onSaved) {
    return TextFormField(
      maxLines: isMultiline ? 4 : 1,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
      onSaved: onSaved, // Save the input value
    );
  }

  // Dropdown for Internship Category with Validator
  Widget _buildDropdown(Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: [
        DropdownMenuItem(value: 'Software', child: Text('Software Development')),
        DropdownMenuItem(value: 'Marketing', child: Text('Marketing')),
        DropdownMenuItem(value: 'Design', child: Text('Design')),
        DropdownMenuItem(value: 'Finance', child: Text('Finance')),
      ],
      onChanged: (value) {
        onChanged(value); // Save the selected category
      },
      validator: (value) {
        if (value == null) {
          return 'Category is required';
        }
        return null;
      },
    );
  }

  // Format the title for use as a Firestore document ID
  String formatTitle(String title) {
    // Replace spaces with underscores and remove special characters
    return title.replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\s]'), '');
  }

// Post Internship Button
  Widget _buildPostButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight, // Align the button to the right
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) { // Check if form is valid
            _formKey.currentState!.save(); // Save the form values

            try {
              // Format the title for use as the document ID
              String formattedTitle = formatTitle(_internshipTitle!);

              // Use the formatted internship title as the document ID in Firestore
              await _firestore.collection('Internship_Posted')
                  .doc(_category) // Use the selected category as the document
                  .collection('Opportunities')
                  .doc(formattedTitle) // Use the formatted title as document ID
                  .set({
                'title': _internshipTitle,
                'description': _internshipDescription,
                'requirements': _requirements,
                'location': _location,
                'duration': _duration,
                'stipend': _stipend,
                'category': _category,
                'postingDate': FieldValue.serverTimestamp(), // Add the posting date
                'timestamp': FieldValue.serverTimestamp(), // Add a separate timestamp if needed
              });

              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success!', style: TextStyle(color: Colors.teal)),
                    content: Text('Internship opportunity posted successfully!'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Optionally, reset the form
                          _formKey.currentState?.reset();
                        },
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              // Show error dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error', style: TextStyle(color: Colors.red)),
                    content: Text('Failed to post internship: $e'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Adjust padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Reduce the button size
          children: [
            Text('Post Internship'),
            SizedBox(width: 8), // Space between text and icon
            Icon(Icons.send),
          ],
        ),
      ),
    );
  }



}