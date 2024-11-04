import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internhub/Home/Applications.dart';
import 'package:internhub/Home/Applicationpage.dart';
import 'package:internhub/Home/FeedbackForm.dart';
import 'package:internhub/Home/InternshipTips.dart';
import 'package:internhub/Home/NetworkingOpportunities.dart';
import 'package:internhub/Home/UserDetails.dart';
import 'package:internhub/Home/Vacancies.dart';


void main() {
  runApp(MaterialApp(
    home: Search(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Color(0xFFEAF2FD),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> internships = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInternships();
  }

  Future<void> _fetchInternships() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<String> categories = ['Marketing', 'Design'];
      List<Map<String, dynamic>> fetchedInternships = [];

      for (String category in categories) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('Internship_Posted')
            .doc(category)
            .collection('Opportunities')
            .get();

        querySnapshot.docs.forEach((doc) {
          fetchedInternships.add({
            'id': doc.id,
            'title': doc['title'] ?? 'No Title',
            'description': doc['description'] ?? 'No Description',
            'category': category,
            'duration': doc['duration'] ?? 'No Duration',
            'location': doc['location'] ?? 'No Location',
            'requirements': doc['requirements'] ?? 'No Requirements',
            'stipend': doc['stipend'] ?? 'No Stipend',
            'postingDate': (doc['timestamp'] as Timestamp).toDate(),
            'deadline': (doc['timestamp'] as Timestamp).toDate().add(Duration(days: 14)),
          });
        });
      }

      setState(() {
        internships = fetchedInternships;
        searchResults = internships;
      });
    } catch (e) {
      _showSnackBar('Error fetching internships: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = internships
          .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Job', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Internship Tips'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InternshipTips())),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Networking Opportunities'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkingOpportunities())),
            ),
            ListTile(
              leading: Icon(Icons.business_center),
              title: Text('Vacancies'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Vacancies())),
            ),
            ListTile(
              leading: Icon(Icons.work_outline),
              title: Text('My Applications'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Applications())),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Your Profile'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails())),
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Give Feedback'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackForm())),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SearchBar(onQueryChanged: onQueryChanged),
                Expanded(
                  child: searchResults.isEmpty
                      ? Center(child: Text('No results found.'))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return JobCard(
                              title: searchResults[index]['title'],
                              category: searchResults[index]['category'],
                              stipend: searchResults[index]['stipend'],
                              isPromoted: index == 0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VacancyDetails(
                                      vacancyId: searchResults[index]['id'],
                                      category: searchResults[index]['category'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onQueryChanged;

  const SearchBar({required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Enter job title or keyword',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String category;
  final String stipend;
  final bool isPromoted;
  final VoidCallback onTap;

  const JobCard({
    required this.title,
    required this.category,
    required this.stipend,
    required this.isPromoted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      color: isPromoted ? Color(0xFF4A90E2) : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPromoted ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          "$category • $stipend",
          style: TextStyle(
            color: isPromoted ? Colors.white70 : Colors.grey[700],
          ),
        ),
        trailing: Text(
          isPromoted ? 'Promoted' : 'Recommended',
          style: TextStyle(
            color: isPromoted ? Colors.white : Colors.black,
          ),
        ),
        onTap: onTap,
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
                Text(data['title'] ?? 'No Title', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Location: ${data['location'] ?? 'No Location'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Duration: ${data['duration'] ?? 'No Duration'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Stipend: \$${data['stipend'] ?? 'No Stipend'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Requirements: ${data['requirements'] ?? 'No Requirements'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Posted on: ${data['postingDate'] != null ? (data['postingDate'] as Timestamp).toDate().toString() : 'No Date'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text('Description', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(data['description'] ?? 'No Description', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
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
