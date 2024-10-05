import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this is imported

class InterviewPreparation extends StatelessWidget {
  // Sample list of interview preparation tips
  final List<String> preparationTips = [
    "1. Research the company and role.",
    "2. Practice common interview questions.",
    "3. Prepare your own questions to ask.",
    "4. Dress appropriately and professionally.",
    "5. Practice good body language.",
    "6. Prepare examples of your past work.",
    "7. Be aware of your online presence.",
    "8. Follow up with a thank-you note.",
  ];

  // Sample list of resources
  final List<Map<String, String>> resources = [
    {
      "title": "Interviewing Techniques",
      "url": "https://example.com/interviewing-techniques",
    },
    {
      "title": "Common Interview Questions",
      "url": "https://example.com/common-interview-questions",
    },
    {
      "title": "Dress Code for Interviews",
      "url": "https://example.com/dress-code",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Preparation'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title for Tips Section
            Text(
              'Preparation Tips:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            // Tips List
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: preparationTips.length,
                separatorBuilder: (context, index) => Divider(height: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      preparationTips[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Title for Resources Section
            Text(
              'Helpful Resources:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            // Resources List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      resources[index]["title"]!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple),
                    onTap: () {
                      // Open the URL in a web browser
                      launchURL(resources[index]["url"]!);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch URLs
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
