import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internhub/Home/HomePage.dart';
import 'package:internhub/LogIn_%20And_Register/companyRegister.dart';
import 'package:internhub/LogIn_%20And_Register/internRegister.dart'; // Import the HomePage

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

  Future<void> _logIn() async {
    setState(() {
      _errorMessage = null; // Reset the error message
    });

    if (isDesktopScreen(context)) {
      if (_companyNameController.text.isEmpty) {
        setState(() {
          _errorMessage = "Company Name is required for login.";
        });
        return;
      }
    } else if (!isMobileScreen(context)) {
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
            builder: (context) => HomePage(
              userRole: isDesktopScreen(context) ? 'Company' : 'Intern',
            ), // Pass user role
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Set appropriate error message
        setState(() {
          _errorMessage = e.code == 'user-not-found' || e.code == 'wrong-password'
              ? "Incorrect Email or Password"
              : "Error: ${e.message}";
        });
      }
    }
  }

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
    final isDesktop = isDesktopScreen(context);

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
                          isDesktop ? 'Company Login' : 'Intern Login',
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
                        if (isDesktop)
                          TextFormField(
                            controller: _companyNameController,
                            decoration: InputDecoration(
                              labelText: 'Company Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Company Name';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
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
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _logIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                            // Sign Up Button
                       SizedBox(height: 10),
TextButton(
  onPressed: () {
    // Navigate to appropriate registration screen based on screen size
    if (isDesktopScreen(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterCompany()),
      ); // Company registration
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      ); // Intern registration
    }
  },
  child: Text(
    'Don\'t have an account? Sign Up',
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
