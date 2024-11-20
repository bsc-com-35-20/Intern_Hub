

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:internhub/LogIn_ And_Register/Log_In.dart';
import 'package:internhub/LogIn_%20And_Register/companyRegister.dart';
import 'package:internhub/LogIn_%20And_Register/internRegister.dart';
import 'package:internhub/Settings/UpdateProfile.dart';
import 'firebase_options.dart';
import 'package:internhub/Home/HomePage.dart';
import 'package:internhub/Home/Vacancies.dart';
import 'package:internhub/SplashScreen.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
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
      initialRoute: 
      '/', 

      routes: {
        '/': (context) => SplashScreen(),
        '/LogIn': (context) => Log_In(), // Define LogIn route
        '/companyRegister': (context) => RegisterCompany(), 
        '/internRegister': (context) => Register(), 
        '/Home': (context) => HomePage(userRole: ModalRoute.of(context)!.settings.arguments as String), // Pass userRole
        '/UpdateProfile':(context) => UpdateProfile(),
        '/Vacancies':(context) => Vacancies(),
        

      },
      // or use onGenerateRoute if you want more dynamic route handling
    );
  }
}


