import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internhub/Home/Vacancies.dart';

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
  List<String> localData = ['Apple', 'Banana', 'Cherry', 'Date'];
  List<String> onlineData = [];
  List<String> searchResults = [];
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _fetchOnlineData();
    } else {
      _showSnackBar('No internet connection. Loading local data.');
      await _loadLocalData();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchOnlineData() async {
    try {
      final List<String> urls = [
        'https://www.rootsinterns.com/destinations/internships-malawi/',
        'https://ntchito.com/apply-for-internships-in-malawi/',
      ];

      for (String url in urls) {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          List internships = jsonDecode(response.body);
          onlineData.addAll(
              internships.map((e) => e['title'] as String).toList());
        }
      }
      await _saveLocalData(onlineData);
    } catch (e) {
      _showSnackBar('Failed to fetch online data. Loading local data.');
      await _loadLocalData();
    }
  }

  Future<void> _saveLocalData(List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('internships', data);
  }

  Future<void> _loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localData = prefs.getStringList('internships') ?? localData;
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = [
        ...localData,
        ...onlineData,
      ].where((item) =>
          item.toLowerCase().contains(query.toLowerCase())).toList();
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                SearchBar(onQueryChanged: onQueryChanged),
                Expanded(
                  child: searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: Icon(Icons.work_outline),
                                title: Text(searchResults[index]),
                                onTap: () {
                                  _showSnackBar(
                                      'Selected: ${searchResults[index]}');
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
    return Container(
      padding: EdgeInsets.all(16),
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
