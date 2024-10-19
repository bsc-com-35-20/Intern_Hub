import 'package:flutter/material.dart';

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
      ),
      initialRoute: '/HomePage',
      routes: {
        '/': (context) => EmployersDashBoard(),
        '/PostInternship': (context) => PostInternshipPage(),
        '/ViewApplications': (context) => ViewApplicationsPage(),
        '/ManageCandidates': (context) => ManageCandidatesPage(),
        '/Statistics': (context) => StatisticsPage(),
      },
    );
  }
}

class EmployersDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employers Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Employer Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to Home
                Navigator.pushReplacementNamed(context, '/Home');
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Post Internship'),
              onTap: () {
                Navigator.pushNamed(context, '/PostInternship');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Applications'),
              onTap: () {
                Navigator.pushNamed(context, '/ViewApplications');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Manage Candidates'),
              onTap: () {
                Navigator.pushNamed(context, '/ManageCandidates');
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pushNamed(context, '/Statistics');
              },
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome to the Employers Dashboard!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildDashboardCard(
                    context,
                    Icons.assignment,
                    'Post New Internship',
                    '/PostInternship',
                  ),
                  _buildDashboardCard(
                    context,
                    Icons.list_alt,
                    'View Applications',
                    '/ViewApplications',
                  ),
                  _buildDashboardCard(
                    context,
                    Icons.person_add,
                    'Manage Candidates',
                    '/ManageCandidates',
                  ),
                  _buildDashboardCard(
                    context,
                    Icons.analytics,
                    'Statistics',
                    '/Statistics',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, String route) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.red),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostInternshipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post New Internship')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Internship Title'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Requirements'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Application Deadline'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle posting internship
              },
              child: Text('Post Internship'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewApplicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Applications')),
      body: ListView.builder(
        itemCount: 10, // Replace with actual number of applications
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Application #${index + 1}'),
              subtitle: Text('Candidate Name'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to application details
              },
            ),
          );
        },
      ),
    );
  }
}

class ManageCandidatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Candidates')),
      body: ListView.builder(
        itemCount: 5, // Replace with actual number of candidates
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Candidate #${index + 1}'),
              subtitle: Text('Resume Details'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to candidate details
              },
            ),
          );
        },
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: Text(
          'Statistics will be shown here',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
