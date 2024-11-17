import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internhub/Home/HomePage.dart';

class Log_In extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isDesktopScreen(context)) {
      return CompanyLogin();
    } else if (isMobileScreen(context)) {
      return InternLogin();
    } else {
      return Scaffold(
        body: Center(
          child: Text(
            'Unsupported screen size.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }
  }
}

// Helper functions for screen size detection
bool isMobileScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < 800;
}

bool isDesktopScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= 800;
}

// Shared Login Widget
class LoginForm extends StatelessWidget {
  final bool isCompany;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController companyNameController;
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onLogin;

  const LoginForm({
    required this.isCompany,
    required this.emailController,
    required this.passwordController,
    required this.companyNameController,
    required this.formKey,
    required this.onLogin,
  });

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
                key: formKey,
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
                          isCompany ? 'Company Login' : 'Intern Login',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const SizedBox(height: 20),
                        if (isCompany)
                          TextFormField(
                            controller: companyNameController,
                            decoration: InputDecoration(
                              labelText: 'Company Name',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await onLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Log In',
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
      ),
    );
  }
}

class CompanyLogin extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _logIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Check company name
      final companyName = _companyNameController.text.trim();
      final email = _emailController.text.trim();
      final isValidCompany = await FirebaseFirestore.instance
          .collection('Company_Details')
          .doc(email)
          .get()
          .then((doc) => doc.exists && doc.data()?['companyName']?.toUpperCase() == companyName.toUpperCase());

      if (!isValidCompany) {
        Fluttertoast.showToast(msg: 'Company name does not match the registered email.');
        return;
      }

      // Sign in with Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userRole: 'Company'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'An error occurred during login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginForm(
      isCompany: true,
      emailController: _emailController,
      passwordController: _passwordController,
      companyNameController: _companyNameController,
      formKey: _formKey,
      onLogin: () => _logIn(context),
    );
  }
}

class InternLogin extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _logIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Sign in with Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userRole: 'Intern'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'An error occurred during login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginForm(
      isCompany: false,
      emailController: _emailController,
      passwordController: _passwordController,
      companyNameController: TextEditingController(),
      formKey: _formKey,
      onLogin: () => _logIn(context),
    );
  }
}
