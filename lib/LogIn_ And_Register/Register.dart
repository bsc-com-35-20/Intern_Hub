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
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  String? _selectedGender;
  bool _isCompany = false; // Toggle between Intern and Company/Employee
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _saveCompanyDetails(User user) async {
    try {
      // Save company details in Firestore
      await FirebaseFirestore.instance
          .collection('Company_Details')
          .doc(user.email)
          .set({
        'companyName': _companyNameController.text.trim(),
        'email': user.email,
        'companyAddress': _companyAddressController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Optionally, you can add a success message or perform further actions
      print('Company details saved successfully.');
    } catch (e) {
      // Handle any errors
      print('Error saving company details: $e');
    }
  }

  Future<void> _saveInternDetails(User user) async {
    try {
      // Save intern details in Firestore
      await FirebaseFirestore.instance
          .collection('Intern_Personal_Details') // Correct collection name
          .doc(user.email) // Using the user's email as the document ID
          .set({
        'name': _nameController.text.trim(),
        'email': user.email,
        'phone number': _phoneNumberController,
        'age': _ageController.text.trim(),
        'gender': _selectedGender,
        'createdAt': Timestamp.now(),
      });

      // Optionally, you can add a success message or perform further actions
      print('Intern details saved successfully.');
    } catch (e) {
      // Handle any errors
      print('Error saving intern details: $e');
    }
  }

  void _showSuccessToast([String message = "Registered Successfully"]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.blue,
      fontSize: 16.0,
    );
  }

  Future<void> _registerCompany() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save company details to Firestore without logging in the user
        await _saveCompanyDetails(userCredential.user!);

        // Show success message
        _showSuccessToast();

        // Do not log in the user automatically, let them manually log in later
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

  Future<void> _registerIntern() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save intern details to Firestore
        await _saveInternDetails(userCredential.user!);

        // Show success message for intern registration
        _showSuccessToast();

        // Do not log in the user automatically, let them manually log in later
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

  // Email validation function
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
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
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        SizedBox(height: 20),

                        // Toggle for Intern or Company Registration
                        ToggleButtons(
                          isSelected: [_isCompany, !_isCompany],
                          children: [Text('Company'), Text('Intern')],
                          onPressed: (int index) {
                            setState(() {
                              _isCompany = index == 0;
                            });
                          },
                          color: Colors.blueAccent,
                          selectedColor: Colors.white,
                          fillColor: Colors.blueAccent,
                          selectedBorderColor: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 20),

                        // Display fields based on selected option
                        _isCompany ? _buildCompanyForm() : _buildInternForm(),

                        SizedBox(height: 30),
                        // Register Button for Company and Intern
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isCompany ? _registerCompany : _registerIntern,
                            child: Text('Register'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Switch to Log In
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/LogIn');
                          },
                          child: Text('Already have an Account? Log In',
                              style: TextStyle(color: Colors.blue)),
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

  // Build form for intern registration
  Widget _buildInternForm() {
    return Column(
      children: [
        // Name Field
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
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
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
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
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          value: _selectedGender,
          items: ['Male', 'Female', 'Other'].map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
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
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Email';
            }
            if (!_isEmailValid(value)) {
              return 'Please enter a valid Email';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
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
      ],
    );
  }

  // Build form for company registration
  Widget _buildCompanyForm() {
    return Column(
      children: [
        // Company Name Field
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
        // Company Address Field
        TextFormField(
          controller: _companyAddressController,
          decoration: InputDecoration(
            labelText: 'Company Address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Company Address';
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
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Email';
            }
            if (!_isEmailValid(value)) {
              return 'Please enter a valid Email';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
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
      ],
    );
  }
}
