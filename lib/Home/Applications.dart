import 'package:flutter/material.dart';

class Application {
  final String internshipTitle;
  final String company;
  final String status;
  final String submissionDate;
  final String details; // Added details field

  Application({
    required this.internshipTitle,
    required this.company,
    required this.status,
    required this.submissionDate,
    required this.details, // Added details field in constructor
  });
}

class Applications extends StatefulWidget {
  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  final List<Application> applications = [
    Application(
      internshipTitle: 'Software Engineering Intern',
      company: 'Tech Solutions',
      status: 'Applied',
      submissionDate: '2024-09-01',
      details: 'This internship involves working on software development projects using modern technologies.',
    ),
    Application(
      internshipTitle: 'Marketing Intern',
      company: 'Creative Agency',
      status: 'Interview Scheduled',
      submissionDate: '2024-09-10',
      details: 'You will assist in digital marketing campaigns and content creation.',
    ),
    Application(
      internshipTitle: 'Data Analyst Intern',
      company: 'Data Corp',
      status: 'Rejected',
      submissionDate: '2024-09-15',
      details: 'This position focuses on analyzing data sets to derive actionable insights.',
    ),
  ];

  List<Application> filteredApplications = [];

  @override
  void initState() {
    super.initState();
    filteredApplications = applications;
  }

  void _filterApplications(String query) {
    final results = applications.where((application) {
      final internshipTitleLower = application.internshipTitle.toLowerCase();
      final companyLower = application.company.toLowerCase();
      final searchLower = query.toLowerCase();

      return internshipTitleLower.contains(searchLower) ||
          companyLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredApplications = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Applications'),
        backgroundColor: Colors.teal[700], // Darker teal for a modern look
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                onChanged: (query) => _filterApplications(query),
                decoration: InputDecoration(
                  labelText: 'Search Applications',
                  prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredApplications.length,
                itemBuilder: (context, index) {
                  final application = filteredApplications[index];
                  return _buildApplicationCard(application);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Application application) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        title: Text(
          application.internshipTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.teal[700],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Company: ${application.company}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  application.status == 'Applied'
                      ? Icons.access_time_rounded
                      : application.status == 'Interview Scheduled'
                      ? Icons.check_circle_outline
                      : Icons.cancel,
                  color: application.status == 'Applied'
                      ? Colors.orange
                      : application.status == 'Interview Scheduled'
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: ${application.status}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Submitted on: ${application.submissionDate}',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal[700]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicationDetailPage(application: application),
            ),
          );
        },
      ),
    );
  }
}

class ApplicationDetailPage extends StatelessWidget {
  final Application application;

  ApplicationDetailPage({required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(application.internshipTitle),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company: ${application.company}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  application.status == 'Applied'
                      ? Icons.access_time_rounded
                      : application.status == 'Interview Scheduled'
                      ? Icons.check_circle_outline
                      : Icons.cancel,
                  color: application.status == 'Applied'
                      ? Colors.orange
                      : application.status == 'Interview Scheduled'
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: ${application.status}',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Submitted on: ${application.submissionDate}',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            SizedBox(height: 20),
            Text(
              'Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Text(
              application.details, // Displaying the details here
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Action for button (e.g., withdraw application, etc.)
              },
              child: Text('Take Action'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
