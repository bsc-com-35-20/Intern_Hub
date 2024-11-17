import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class NotificationService {
  static const String serverKey = "YOUR_SERVER_KEY";

  static Future<void> sendNotification(String token, String title, String body) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<void> notifyUser(String userId, String title, String body) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String? token = userDoc['fcmToken'];

    if (token != null) {
      await sendNotification(token, title, body);
    } else {
      print("No FCM token found for user $userId");
    }
  }
}
