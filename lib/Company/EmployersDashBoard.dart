import 'package:flutter/material.dart';
import 'package:internhub/Company/ManageInternships.dart';
import 'package:internhub/Company/PostInternship.dart';

class EmployersDashBoard extends StatefulWidget {
  @override
  _EmployersDashBoardState createState() => _EmployersDashBoardState();
}

class _EmployersDashBoardState extends State<EmployersDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'For Companies',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 24),
            _buildOptionsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to InternHub for Companies!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Connect with interns and manage your internship programs seamlessly.',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.teal.shade700, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Unlock access to a talented pool of interns.',
                      style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.group, color: Colors.teal.shade700, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Collaborate with educational institutions to develop future professionals.',
                      style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildOptionsList(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildOptionTile(
            icon: Icons.post_add,
            title: 'Post Internship Opportunities',
            subtitle: 'Share your internship listings with aspiring students. Attract fresh talent with tailored internship roles.',
            color: Colors.teal,
            onTap: () {
              if (mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostInternship()));
              }
            },
          ),
          _buildOptionTile(
            icon: Icons.assessment,
            title: 'Manage Internships',
            subtitle: 'Track the progress of your interns, assign tasks, and provide valuable feedback.',
            color: Colors.teal,
            onTap: () {
              if (mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageInternship()));
              }
            },
          ),
          _buildOptionTile(
            icon: Icons.analytics,
            title: 'Internship Analytics',
            subtitle: 'Get insights into internship program performance.',
            color: Colors.teal,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InternshipAnalytics()));
            },
          ),
          _buildOptionTile(
            icon: Icons.notifications,
            title: 'Internship Alerts',
            subtitle: 'Set up notifications to stay updated on applications and key milestones.',
            color: Colors.teal,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InternshipAlerts()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(icon, size: 30, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueAccent),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[700])),
        onTap: onTap,
      ),
    );
  }
}
// Internship Analytics Page
class InternshipAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Analytics'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildAnalyticsCard('Internship Completion Rate', '85%', Icons.show_chart, Colors.green),
            _buildAnalyticsCard('Average Feedback Score', '4.5/5', Icons.thumb_up, Colors.blue),
            _buildAnalyticsCard('Interns Hired Full-time', '12', Icons.people, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
    );
  }
}

// Internship Alerts Page
class InternshipAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Alerts'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Alerts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Application Received'),
              subtitle: Text('Get notified when a new application is submitted.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Internship Completed'),
              subtitle: Text('Get notified when an intern completes their internship.'),
              value: false,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
            SwitchListTile(
              title: Text('Feedback Received'),
              subtitle: Text('Get notified when feedback is submitted by an intern.'),
              value: true,
              onChanged: (value) {
                // Logic to handle switch
              },
              activeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}