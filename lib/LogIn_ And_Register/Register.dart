import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  String? _selectedGender;
  bool _obscurePassword = true; // To toggle password visibility
  bool _obscureConfirmPassword = true; // To toggle confirm password visibility

  Future<void> _saveUserDetails(User user) async {
    await FirebaseFirestore.instance.collection('Intern_Personal_Details').doc(user.email).set({
      'name': _nameController.text.trim(),
      'email': user.email,
      'age': _ageController.text.trim(),
      'gender': _selectedGender ?? 'Unknown',
      'createdAt': Timestamp.now(),
      'profilePictureUrl': '',
    });
  }

  void _showSuccessToast([String message = "Registered Successfully"]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.blue,
      fontSize: 16.0,
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save user details to Firestore
        await _saveUserDetails(userCredential.user!);

        // Show success message
        _showSuccessToast();

        // Navigate to the next screen (e.g., Home screen)
        Navigator.pushReplacementNamed(context, '/Home');
      } on FirebaseAuthException catch (e) {
        // Show error message
        String message = e.message ?? "Registration failed";
        Fluttertoast.showToast(
          msg: message,
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
                          'Register',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(height: 20),
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Full Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Age Field
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Age';
                            }
                            int? age = int.tryParse(value);
                            if (age == null || age < 18 || age > 50) {
                              return 'Please enter a valid age (18-50)';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Gender Field
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                          ),
                          value: _selectedGender,
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your Gender';
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
                            if (!RegExp(
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
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword; // Toggle password visibility
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
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            filled: true,
                            fillColor: Colors.grey[200], // Light background
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle confirm password visibility
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your Password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            child: Text('Register'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded button
                              ),
                              backgroundColor: Colors.blueAccent, // Button color
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Switch to Log In
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/LogIn');
                          },
                          child: Text('Already have an Account? Log In', style: TextStyle(color: Colors.blue)),
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
