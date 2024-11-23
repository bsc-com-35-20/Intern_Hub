import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New password and confirmation do not match.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null && currentPassword.isNotEmpty) {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your current password.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'Current password is incorrect.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'New password is too weak. Choose a stronger password.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print('Error changing password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPasswordField(
              'Current Password', 
              _currentPasswordController, 
              _currentPasswordVisible, 
              () {
                setState(() {
                  _currentPasswordVisible = !_currentPasswordVisible;
                });
              }
            ),
            SizedBox(height: 16),
            _buildPasswordField(
              'New Password', 
              _newPasswordController, 
              _newPasswordVisible, 
              () {
                setState(() {
                  _newPasswordVisible = !_newPasswordVisible;
                });
              }
            ),
            SizedBox(height: 16),
            _buildPasswordField(
              'Confirm New Password', 
              _confirmPasswordController, 
              _confirmPasswordVisible, 
              () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              }
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _buildStyledButton('Change Password', _changePassword),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 64, 115, 255),
        padding: EdgeInsets.symmetric(vertical: 15.0),
        textStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title),
    );
  }

  Widget _buildPasswordField(
      String label, 
      TextEditingController controller, 
      bool isPasswordVisible, 
      VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
