

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:internhub/LogIn_ And_Register/Log_In.dart';
import 'package:internhub/LogIn_ And_Register/Register.dart';
import 'firebase_options.dart';
import 'package:internhub/Home/HomePage.dart';
import 'package:internhub/Home/Vacancies.dart';
import 'package:internhub/Vacancy/VacancyDetails1.dart';
import 'package:internhub/Vacancy/VacancyDetails2.dart';
import 'package:internhub/Vacancy/VacancyDetails3.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Make sure this is set up
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/LogIn', // Set initial route

      routes: {


        '/LogIn': (context) => Log_In(), // Define LogIn route
        '/Register': (context) => Register(), // Define Register route
        '/Home': (context) => HomePage(),

        '/VacancyDetails1': (context) => VacancyDetails1(),
        '/VacancyDetails2': (context) => VacancyDetails2(),
        '/VacancyDetails3': (context) => VacancyDetails3(),


      },
      // or use onGenerateRoute if you want more dynamic route handling
    );
  }
}


