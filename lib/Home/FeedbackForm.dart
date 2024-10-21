import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0; // Rating variable
  bool _isSubmitting = false; // Submit status
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitFeedback() async {
    // Check for empty feedback or rating
    if (_feedbackController.text.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide feedback and a rating!')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Set loading status
    });

    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user == null || user.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in or email not available!')),
        );
        return;
      }

      // Get the user's email
      String userEmail = user.email!;

      // Check if feedback document exists for this user's email
      DocumentReference feedbackDocRef = FirebaseFirestore.instance.collection('Intern_Feedback').doc(userEmail);
      DocumentSnapshot feedbackDoc = await feedbackDocRef.get();

      if (feedbackDoc.exists) {
        // If feedback already exists, update it instead of adding a new one
        await feedbackDocRef.update({
          'Intern_Feedback': _feedbackController.text,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Save new feedback to Firestore
        await feedbackDocRef.set({
          'userEmail': userEmail,
          'feedback': _feedbackController.text,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );

      // Clear the fields
      _feedbackController.clear();
      setState(() {
        _rating = 0.0; // Reset rating
      });
    } catch (e) {
      // Show error message if there's an issue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Reset loading status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.teal, // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Allow scrolling if keyboard pops up
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We value your feedback!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 20),
              Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0; // Set the rating
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your feedback here...',
                  hintStyle: TextStyle(color: Colors.grey[600]), // Hint color
                  filled: true,
                  fillColor: Colors.grey[200], // Background color of the text field
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Center( // Center the button
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitFeedback, // Disable button while submitting
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding
                    textStyle: TextStyle(fontSize: 18), // Text style
                  ),
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white) // Show loader when submitting
                      : Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
