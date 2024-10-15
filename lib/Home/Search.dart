import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Search(),
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _fetchOnlineData();
    } else {
      await _loadLocalData();
    }
  }

  Future<void> _fetchOnlineData() async {
    try {
      final response = await http.get(Uri.parse('https://www.rootsinterns.com/destinations/internships-malawi/'));
      if (response.statusCode == 200) {
        List internships = jsonDecode(response.body);
        onlineData = internships.map((e) => e['title'] as String).toList();
        await _saveLocalData(onlineData);
      }
    } catch (e) {
      print('Failed to fetch online data: $e');
      await _loadLocalData();
    }
    setState(() {});
  }

  Future<void> _saveLocalData(List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('internships', data);
  }

  Future<void> _loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localData = prefs.getStringList('internships') ?? localData;
    setState(() {});
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = [
        ...localData,
        ...onlineData,
      ].where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Search'),
      ),
      body: Column(
        children: [
          SearchBar(onQueryChanged: onQueryChanged),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onQueryChanged;

  const SearchBar({required this.onQueryChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: widget.onQueryChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
