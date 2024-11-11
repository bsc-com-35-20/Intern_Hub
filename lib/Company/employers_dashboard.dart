import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployersDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'For Companies',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 24),
            _buildOptionsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to InternHub for Companies!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Connect with interns and manage your internship programs seamlessly.',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.teal.shade700, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Unlock access to a talented pool of interns.',
                      style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.group, color: Colors.teal.shade700, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Collaborate with educational institutions to develop future professionals.',
                      style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildOptionTile(
            icon: Icons.post_add,
            title: 'Post Internship Opportunities',
            subtitle: 'Share your internship listings with aspiring students. Attract fresh talent with tailored internship roles.',
            color: Colors.teal,
           onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostInternship()));
            },
          ),

          _buildOptionTile(
            icon: Icons.assessment,
            title: 'Manage Internships',
            subtitle: 'Track the progress of your interns, assign tasks, and provide valuable feedback.',
            color: Colors.teal,
         onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageInternship()));
            },
          ),
          _buildOptionTile(
            icon: Icons.analytics,
            title: 'Internship Analytics',
            subtitle: 'Get detailed insights into internship program performance, completion rates, and feedback.',
            color: Colors.teal,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InternshipAnalytics()));
            },
          ),
          _buildOptionTile(
            icon: Icons.notifications,
            title: 'Internship Alerts',
            subtitle: 'Set up notifications to stay updated on applications and key internship milestones.',
            color: Colors.teal,
           onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InternshipAlerts()));
            },
          ),

        ],
      ),


    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(icon, size: 30, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueAccent),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[700])),
        onTap: onTap,
      ),
    );
  }
}

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
                'salary': _stipend,
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

// Manage Internships Page
class ManageInternship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Internships'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Active Internships',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInternshipCard('Software Development Intern', 'In Progress', context),
            _buildInternshipCard('Marketing Intern', 'Completed', context),
            _buildInternshipCard('Data Science Intern', 'In Progress', context),
          ],
        ),
      ),
    );
  }

  Widget _buildInternshipCard(String title, String status, BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.work_outline, color: Colors.teal, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text('Status: $status'),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          // Navigate to more details about the internship
        },
      ),
    );
  }
}

// Internship Analytics Page
class InternshipAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Analytics'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildAnalyticsCard('Internship Completion Rate', '85%', Icons.show_chart, Colors.green),
            _buildAnalyticsCard('Average Feedback Score', '4.5/5', Icons.thumb_up, Colors.blue),
            _buildAnalyticsCard('Interns Hired Full-time', '12', Icons.people, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
    );
  }
}

// Internship Alerts Page
class InternshipAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Alerts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Application Received'),
              subtitle: Text('Get notified when a new application is submitted.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Internship Completed'),
              subtitle: Text('Get notified when an intern completes their internship.'),
              value: false,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Feedback Received'),
              subtitle: Text('Get notified when feedback is submitted by an intern.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}