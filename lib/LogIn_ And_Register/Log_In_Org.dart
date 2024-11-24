import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internhub/Company/employers_dashboard.dart';
import 'package:internhub/Home/Search.dart';

class Log_In extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<Log_In> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _role = 'Intern'; // Default role

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determineRole();
    });
  }

  void _determineRole() {
    setState(() {
      _role = MediaQuery.of(context).size.width < 800 ? 'Intern' : 'Company';
    });
  }

  Future<void> _logIn() async {
    setState(() => _isLoading = true);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final email = _emailController.text.trim();

        // Check Firestore collections to determine where to navigate
        final internDetails = await FirebaseFirestore.instance
            .collection('Intern_Personal_Details')
            .doc(email)
            .get();

        if (internDetails.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Search()),
          );
          return;
        }

        final companyDetails = await FirebaseFirestore.instance
            .collection('Company_Details')
            .doc(email)
            .get();

        if (companyDetails.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmployersDashBoard()),
          );
          return;
        }

        // If user is not found in either collection
        _showSnackBar("User details not found. Please contact support.");
      } on FirebaseAuthException catch (e) {
        _showSnackBar(e.code == 'user-not-found' || e.code == 'wrong-password'
            ? "Incorrect Email or Password"
            : "An error occurred. Please try again.");
      }
    }
    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: const Color.fromARGB(255, 187, 222, 252)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E9EAB), Color(0xFFeef2f3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 350,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Role Display
                      Text(
                        "Role: $_role",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            const Color.fromARGB(255, 187, 222, 252)
                                .withOpacity(0.5),
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email ID',
                        icon: Icons.email_outlined,
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (value) {},
                                activeColor: Colors.white,
                              ),
                              Text('Remember me',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Forgot Password?',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _logIn,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 187, 222, 252),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text('LOGIN', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Sign-up Link
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/Register'),
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }
}
