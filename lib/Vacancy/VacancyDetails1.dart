import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Vacancy Details Page 1
class VacancyDetails1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Research Assistants (15) – WASH Projects Sustainability Research',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Organization: Liberty Affiliates\n'
                    'Location: Songani Trading Centre, Zomba\n'
                    'Duration: Short-term Contract (Project-Based)\n'
                    'Application Deadline: 14 October, 2024\n',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Key Responsibilities:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              Text(
                '• Conduct data collection in Songani Trading Centre, including household surveys and community interviews.\n'
                    '• Assist with the organization and management of field data, ensuring accuracy and completeness.\n'
                    '• Engage with community members to gather qualitative and quantitative information on the sustainability of WASH projects.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _launchURL('https://www.linkedin.com/company/lvm-documents-editors-data-entry-servces/');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Apply Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
