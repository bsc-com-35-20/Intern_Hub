import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internhub/Home/HomePage.dart'; // Import the HomePage

bool isMobileScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < 800; // Example breakpoint
}

bool isDesktopScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= 800;
}


class Log_In extends StatefulWidget {
  @override
  _Log_InState createState() => _Log_InState();
}

class _Log_InState extends State<Log_In> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyNameController = TextEditingController(); // Controller for Company Name
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // To toggle password visibility
  String? _errorMessage; // To hold error messages
  bool _isCompany = false; // Declare _isCompany here



  Future<void> _logIn() async {
    setState(() {
      _errorMessage = null; // Reset the error message
    });

      if (_isCompany && !isDesktopScreen(context)) {
  setState(() {
    _errorMessage = "Companies can only log in on larger screens (desktop).";
  });
  return;
} else if (!_isCompany && !isMobileScreen(context)) {
  setState(() {
    _errorMessage = "Interns can only log in on smaller screens (mobile).";
  });
  return;
}

    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Log in with email and password
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userRole: _isCompany ? 'Company' : 'Intern'), // Pass user role
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Check the error code and set appropriate error message
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage = "Incorrect Password"; // Treat unregistered email as incorrect password
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage = "Incorrect Password"; // Wrong password
          });
        } else {
          setState(() {
            _errorMessage = "Email or Password Incorrect"; // Generic message for other errors
          });
        }
      }
    }
  }


  Future<bool> _checkCompanyName(String companyName, String email) async {
    try {
      // Get the document for the specified email
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Company_Details')
          .doc(email) // Use the company email as the document ID
          .get();

      // Check if the document exists and retrieve the company name
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['companyName'] != null) {
          // Compare the company name in a case-insensitive manner
          String storedCompanyName = data['companyName'].toString();
          if (storedCompanyName.toUpperCase() == companyName.toUpperCase()) {
            return true; // Company name matches
          }
        }
      }
      return false; // Return false if document doesn't exist or company name doesn't match
    } catch (e) {
      // Handle permission errors explicitly
      if (e.toString().contains('permission-denied')) {
        print("Permission error when checking company name for email: $email.");
      } else {
        print("Error checking company name for email: $email, company name: $companyName. Error: $e");
      }
      return false; // Return false on error
    }
  }




  // Method to handle password reset
  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Password reset email sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending password reset email.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Method to show forgot password dialog
  void _showForgotPasswordDialog() {
    String email = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextField(
            decoration: InputDecoration(hintText: "Enter your email"),
            onChanged: (value) {
              email = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetPassword(email);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Send"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(height: 20),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        // Toggle for Intern or Company Registration
                        ToggleButtons(
                          isSelected: [_isCompany, !_isCompany],
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Company',
                                style: TextStyle(color: _isCompany ? Colors.white : Colors.blueAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Intern',
                                style: TextStyle(color: !_isCompany ? Colors.white : Colors.blueAccent),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              _isCompany = index == 0;
                              _emailController.clear(); // Clear email controller when switching user types
                              _companyNameController.clear(); // Clear company name controller when switching user types
                            });
                          },
                          color: Colors.blueAccent, // Color of unselected buttons
                          selectedColor: Colors.white, // Color of selected text
                          fillColor: Colors.blueAccent, // Background color of selected button
                          borderColor: Colors.blueAccent, // Border color for unselected buttons
                          selectedBorderColor: Colors.blueAccent, // Border color for selected button
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 20),
                        // Company Name Field (visible only for Company)
                        if (_isCompany)
                          TextFormField(
                            controller: _companyNameController,
                            decoration: InputDecoration(
                              labelText: 'Company Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              filled: true,
                              fillColor: Colors.grey[200], // Light background
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Company Name';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: 20),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            }
                            if (_isCompany && !RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility, // Corrected order
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword; // Toggle password visibility
                                });
                              },
                            ),
                          ),

                          obscureText: _obscurePassword, // Use the toggle state
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null; // Valid input
                          },
                        ),

                        SizedBox(height: 20),
                        // Login Button
                        ElevatedButton(
                          onPressed: _logIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent, // Set button color to blueAccent
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white), // Set text color to white
                          ),
                        ),

                        SizedBox(height: 10),
                        // Forgot Password Button
                        TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        // Sign Up Link
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Register'); // Navigate to the Register page
                          },
                          child: Text(
                            'Already have an Account? Sign Up',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
