import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internhub/Home/ApplicationPage.dart';

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

    );
  }
}

class Vacancies extends StatefulWidget {
  @override
  _VacanciesState createState() => _VacanciesState();
}

class _VacanciesState extends State<Vacancies> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> internships = [];

  @override
  void initState() {
    super.initState();
    _fetchInternships();
  }

  Future<void> _fetchInternships() async {
    try {
      List<String> categories = ['Marketing', 'Design'];
      List<Map<String, dynamic>> fetchedInternships = [];

      for (String category in categories) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('Internship_Posted')
            .doc(category)
            .collection('Opportunities')
            .get();

        querySnapshot.docs.asMap().forEach((index, doc) {
          DateTime postingDate = (doc['timestamp'] as Timestamp).toDate();
          DateTime deadline =
          postingDate.add(Duration(days: 14)); // 2 weeks deadline

          fetchedInternships.add({
            'id': doc.id, // Add doc ID to identify the document
            'title': doc['title'] ?? 'No Title',
            'description': doc['description'] ?? 'No Description',
            'category': category,
            'duration': doc['duration'] ?? 'No Duration',
            'location': doc['location'] ?? 'No Location',
            'requirements': doc['requirements'] ?? 'No Requirements',
            'stipend': doc['stipend'] ?? 'No Stipend',
            'postingDate': postingDate,
            'deadline': deadline,
          });
        });
      }

      fetchedInternships.sort((a, b) => a['title'].compareTo(b['title']));

      setState(() {
        internships = fetchedInternships;
      });
    } catch (e) {
      print('Error fetching internships: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    final List<Map<String, dynamic>> activeVacancies = internships.where((vacancy) {
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
                        activeVacancies[index]["title"],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VacancyDetails(
                              vacancyId: activeVacancies[index]['id'],
                              category: activeVacancies[index]['category'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class VacancyDetails extends StatelessWidget {
  final String vacancyId;
  final String category;

  VacancyDetails({required this.vacancyId, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Internship_Posted')
            .doc(category)
            .collection('Opportunities')
            .doc(vacancyId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Vacancy not found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Location: ${data['location'] ?? 'No Location'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Duration: ${data['duration'] ?? 'No Duration'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Stipend: \$${data['stipend'] ?? 'No Stipend'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Requirements: ${data['requirements'] ?? 'No Requirements'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Posted on: ${data['postingDate'] != null ? (data['postingDate'] as Timestamp).toDate().toString() : 'No Date'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  data['description'] ?? 'No Description',
                  style: TextStyle(fontSize: 16),
                ),
                Center(
                  child: ElevatedButton(
                         onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicationPage(
                                vacancyId: vacancyId,
                                vacancyTitle: data['title'] ?? 'Vacancy',
                                category: category,
                              ),
                            ),
                          );
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Apply Internship',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
