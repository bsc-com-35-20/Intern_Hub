import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this is imported

class NetworkingOpportunities extends StatelessWidget {
  // Sample list of networking tips
  final List<String> networkingTips = [
    "1. Attend industry conferences and workshops.",
    "2. Join professional associations related to your field.",
    "3. Utilize LinkedIn to connect with professionals.",
    "4. Volunteer for events to meet new people.",
    "5. Conduct informational interviews with industry leaders.",
    "6. Participate in online networking groups.",
    "7. Follow up with contacts you meet.",
    "8. Keep your business cards handy.",
  ];

  // Sample list of networking events
  final List<Map<String, String>> events = [
    {
      "title": "Tech Networking Event",
      "date": "October 15, 2024",
      "location": "Virtual",
      "url": "https://example.com/tech-networking",
    },
    {
      "title": "Business Networking Mixer",
      "date": "November 20, 2024",
      "location": "Downtown Community Center",
      "url": "https://example.com/business-mixer",
    },
    {
      "title": "Career Fair",
      "date": "December 5, 2024",
      "location": "City Convention Hall",
      "url": "https://example.com/career-fair",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Networking Opportunities'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Changed color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title for Tips Section
            Text(
              'Networking Tips:',
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
                color: Colors.grey[200], // Light grey background
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: networkingTips.length,
                separatorBuilder: (context, index) => Divider(height: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.network_check, color: Colors.deepPurple),
                    title: Text(
                      networkingTips[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Title for Events Section
            Text(
              'Upcoming Networking Events:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            // Events List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      events[index]["title"]!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${events[index]["date"]!} - ${events[index]["location"]!}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple),
                    onTap: () {
                      // Open the URL in a web browser
                      launchURL(events[index]["url"]!);
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
