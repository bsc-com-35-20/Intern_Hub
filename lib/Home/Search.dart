import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: Search(),
    theme: ThemeData(
      primarySwatch: Colors.indigo,
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
  bool isLoading = false; // Track loading state

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
      List<String> categories = ['Marketing', 'Design']; // Adjust categories as needed
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
            'deadline': (doc['timestamp'] as Timestamp).toDate().add(Duration(days: 14)), // Set deadline
          });
        });
      }

      setState(() {
        internships = fetchedInternships;
        searchResults = internships; // Initialize search results with all internships
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
        title: Text('Internship Search'),
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
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(searchResults[index]['title']),
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
                              ),
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
          labelText: 'Search Internships',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(Icons.search),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
