import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internhub/Vacancy/VacancyDetails1.dart';
import 'package:internhub/Vacancy/VacancyDetails2.dart';
import 'package:internhub/Vacancy/VacancyDetails3.dart';

void main() {
  runApp(InternHubApp());
}

class InternHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternHub',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Vacancies(),
        '/VacancyDetails1': (context) => VacancyDetails1(),
        '/VacancyDetails2': (context) => VacancyDetails2(),
        '/VacancyDetails3': (context) => VacancyDetails3(),
      },
    );
  }
}

class Vacancies extends StatelessWidget {
  // Sample list of vacancies with deadlines
  final List<Map<String, dynamic>> vacancies = [
    {
      "title": "Research Assistants (15) – WASH Projects Sustainability Research",
      "route": '/VacancyDetails1',
      "deadline": DateTime(2024, 10, 15), // Example deadline
    },
    {
      "title": "IT Intern – Software Development at TechConnect",
      "route": '/VacancyDetails2',
      "deadline": DateTime(2024, 10, 5), // Example deadline (past)
    },
    {
      "title": "Marketing Intern – Brand Awareness Campaigns",
      "route": '/VacancyDetails3',
      "deadline": DateTime(2024, 10, 20), // Example deadline
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime today = DateTime.now();

    // Filter vacancies to only include those that haven't expired
    final List<Map<String, dynamic>> activeVacancies = vacancies.where((vacancy) {
      return vacancy["deadline"].isAfter(today);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Released Vacancies'),
        backgroundColor: Colors.redAccent,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[300]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Vacancies',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: activeVacancies.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      title: Text(
                        activeVacancies[index]["title"]!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.info, size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            'Click to view details',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.redAccent,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, activeVacancies[index]["route"]!);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Optional: Add a footer or button here for more actions
          ],
        ),
      ),
    );
  }
}
