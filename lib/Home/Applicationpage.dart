import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internhub/Home/success.dart';

class ApplicationPage extends StatefulWidget {
  final String vacancyId;
  final String vacancyTitle;
  final String category;

  ApplicationPage({required this.vacancyId, required this.vacancyTitle, required this.category});

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController referralNameController = TextEditingController();
  final TextEditingController referralTitleController = TextEditingController();
  final TextEditingController referralOrganizationController = TextEditingController();
  final TextEditingController referralContactController = TextEditingController();
  final TextEditingController referralRelationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        phoneController.text = userDoc.data()?['phone'] ?? '';
      }
    }
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      try {
        final applicationData = {
          'vacancyId': widget.vacancyId,
          'vacancyTitle': widget.vacancyTitle,
          'category': widget.category,
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'coverLetter': coverLetterController.text,
          'referral': {
            'name': referralNameController.text,
            'title': referralTitleController.text,
            'organization': referralOrganizationController.text,
            'contact': referralContactController.text,
            'relation': referralRelationController.text,
          },
          'appliedAt': DateTime.now(),
        };

        // Add to the general Applications collection
        await FirebaseFirestore.instance.collection('Applications').add(applicationData);

        // Add to specific internship application list
        await FirebaseFirestore.instance
            .collection('Internship_Posted')
            .doc(widget.category)
            .collection('Opportunities')
            .doc(widget.vacancyId)
            .collection('Applications')
            .add(applicationData);

        // Small delay for Firestore updates
        await Future.delayed(Duration(milliseconds: 200));

        // Navigate to success page only if the context is valid
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application. Please try again.')),
        );
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.vacancyTitle}'),
        backgroundColor: const Color.fromARGB(255, 4, 171, 151),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: coverLetterController,
                decoration: InputDecoration(labelText: 'Cover Letter'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a cover letter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Referral Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: referralNameController,
                decoration: InputDecoration(labelText: 'Referral Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: referralTitleController,
                decoration: InputDecoration(labelText: 'Referral Title'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: referralOrganizationController,
                decoration: InputDecoration(labelText: 'Referral Organization'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: referralContactController,
                decoration: InputDecoration(labelText: 'Referral Contact'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: referralRelationController,
                decoration: InputDecoration(labelText: 'Relation to Referral'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 171, 151),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit Application', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
