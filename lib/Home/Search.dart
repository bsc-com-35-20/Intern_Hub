import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internhub/Home/Applicationpage.dart';
import 'package:internhub/Home/Applications.dart';
import 'package:internhub/Home/FeedbackForm.dart';
import 'package:internhub/Home/Tips.dart';
import 'package:internhub/Home/UserDetails.dart';
import 'package:internhub/Home/Vacancies.dart';
import 'package:internhub/LogIn_%20And_Register/Log_In.dart';
import 'package:internhub/pages/hahah.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Hahah(),
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//       scaffoldBackgroundColor: Color(0xFFEAF2FD),
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//     ),
//   ));
// }

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> internships = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchInternships();
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.green,
      fontSize: 16.0,
    );
  }

  Future<void> _fetchInternships() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<String> categories = ['Design', 'Marketing', 'Finance', 'Software'];
      List<Map<String, dynamic>> fetchedInternships = [];

      for (String category in categories) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('Internship_Posted')
            .doc(category)
            .collection('Opportunities')
            .get();

        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

          double stipend = 0.0;
          if (data['stipend'] is num) {
            stipend = (data['stipend'] as num).toDouble();
          } else if (data['stipend'] is String) {
            stipend = double.tryParse(data['stipend']) ?? 0.0;
          }

          fetchedInternships.add({
            'id': doc.id,
            'title': data['title'] ?? 'No Title',
            'description': data['description'] ?? 'No Description',
            'category': category,
            'duration': data['duration'] ?? 'No Duration',
            'location': data['location'] ?? 'No Location',
            'requirements': data['requirements'] ?? 'No Requirements',
            'stipend': stipend,
            'postingDate': (data['timestamp'] as Timestamp?)?.toDate(),
            'deadline': (data['timestamp'] as Timestamp?)
                ?.toDate()
                .add(Duration(days: 14)),
          });
        }
      }

      fetchedInternships.sort((a, b) => b['stipend'].compareTo(a['stipend']));

      setState(() {
        internships = fetchedInternships;
        searchResults = internships;
      });
    } catch (e) {
      _showSnackBar('Error fetching internships: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Timer? debounce;

  void onQueryChanged(String query) {
    print('Query Changed : $query');
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        searchResults = internships
            .where((item) =>
                item['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showCategoryFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter by Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: selectedCategory,
                items: ['Marketing', 'Design', 'Finance', 'Software']
                    .map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _applyCategoryFilter,
                child: Text('Apply Filter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyCategoryFilter() {
    Navigator.pop(context);
    setState(() {
      searchResults = internships.where((internship) {
        return selectedCategory == null ||
            internship['category'] == selectedCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Job'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: IconButton(
              icon: Tooltip(
                message: 'Filter',
                child: Icon(Icons.filter_list, color: Colors.black),
              ),
              onPressed: _showCategoryFilterModal,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
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
            leading: Icon(Icons.tips_and_updates),
            title: Text('Tips'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => TipsPage())),
          ),
          ListTile(
            leading: Icon(Icons.work_outline),
            title: Text('My Applications'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Applications())),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Your Profile'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserDetails())),
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Give Feedback'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedbackForm())),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Log_In())),
          ),
        ]),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return JobCard(
                              title: searchResults[index]['title'],
                              category: searchResults[index]['category'],
                              stipend: searchResults[index]['stipend'],
                              isPromoted: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VacancyDetails(
                                      vacancyId: searchResults[index]['id'],
                                      category: searchResults[index]
                                          ['category'],
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
  final double stipend;
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(category,
                  style: TextStyle(fontSize: 14, color: Colors.teal)),
              SizedBox(height: 8),
              Text('Stipend: MWK ${stipend.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
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
                Text(data['title'] ?? 'No Title',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Location: ${data['location'] ?? 'No Location'}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Duration: ${data['duration'] ?? 'No Duration'}',
                    style: TextStyle(fontSize: 18)),
                Text('Stipend: MWK ${data['stipend'] ?? 'No Stipend'}',
                    style: TextStyle(fontSize: 18)),
                Text(
                    'Requirements: ${data['requirements'] ?? 'No Requirements'}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text(
                    'Posted on: ${data['postingDate'] != null ? (data['postingDate'] as Timestamp).toDate().toString() : 'No Date'}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text('Description',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(data['description'] ?? 'No Description',
                    style: TextStyle(fontSize: 16)),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
