import 'package:flutter/material.dart';
import 'package:timestudyapp/pages/home_page.dart';

class TimeStudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.deepPurple, accentColor: Colors.deepPurpleAccent),
        home: Scaffold(body:HomePage()));
  }
}
