import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.green,
      fontSize: 16.0,
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    _showSuccessToast("Logged out successfully");
    Navigator.pushReplacementNamed(context, '/LogIn'); // Navigate to login screen after logout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Update Profile', style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.person, color: Colors.blue),
              onTap: () {
                // Navigate to update profile screen (implement as needed)
                Navigator.pushNamed(context, '/UpdateProfile');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Change Password', style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.lock, color: Colors.blue),
              onTap: () {
                // Navigate to change password screen (implement as needed)
                Navigator.pushNamed(context, '/ChangePassword');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notifications', style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.notifications, color: Colors.blue),
              onTap: () {
                // Navigate to notification settings screen (implement as needed)
                Navigator.pushNamed(context, '/NotificationSettings');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Privacy Policy', style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.privacy_tip, color: Colors.blue),
              onTap: () {
                // Navigate to privacy policy screen (implement as needed)
                Navigator.pushNamed(context, '/PrivacyPolicy');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.logout, color: Colors.red),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
