import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _programController = TextEditingController();

  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot snapshot = await _firestore
            .collection('Intern_Personal_Details')
            .doc(user.email)
            .get();

        if (snapshot.exists) {
          setState(() {
            userDetails = snapshot.data() as Map<String, dynamic>?;

            _phoneController.text = userDetails!['phone'] ?? '';
            _universityController.text = userDetails!['university'] ?? '';
            _programController.text = userDetails!['course'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('Intern_Personal_Details').doc(user.email).update({
          'phone': _phoneController.text,
          'university': _universityController.text,
          'course': _programController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        print('Error updating user details: $e');
      }
    }
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: userDetails == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildProfileField('Name', userDetails!['name']),
              _buildProfileField('Email', userDetails!['email']),
              _buildEditableField('Phone', _phoneController),
              _buildEditableField('University', _universityController),
              _buildEditableField('Program', _programController),
              SizedBox(height: 20),
              _buildStyledButton('Save Changes', _updateUserDetails),
              SizedBox(height: 10),
              _buildStyledButton('Change Password', _navigateToChangePassword),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        textStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title),
    );
  }

  Widget _buildProfileField(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text(
                  value ?? 'N/A',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _changePassword() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String oldPassword = _oldPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      // Validate the passwords
      if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields.')),
        );
        return;
      }

      if (newPassword == oldPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New password must be different from old password.')),
        );
        return;
      }

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New passwords do not match.')),
        );
        return;
      }

      try {
        // Reauthenticate the user with the old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );

        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        print('Error changing password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect old password. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildPasswordField('Old Password', _oldPasswordController, true),
              _buildPasswordField('New Password', _newPasswordController, _newPasswordVisible),
              _buildPasswordField('Confirm Password', _confirmPasswordController, _confirmPasswordVisible),
              SizedBox(height: 20),
              _buildStyledButton('Change Password', _changePassword),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        textStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title),
    );
  }

  Widget _buildPasswordField(String title, TextEditingController controller, bool isVisible) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    labelText: title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.teal,
                ),
                onPressed: () {
                  setState(() {
                    if (title == 'New Password') {
                      _newPasswordVisible = !_newPasswordVisible;
                    } else if (title == 'Confirm Password') {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
