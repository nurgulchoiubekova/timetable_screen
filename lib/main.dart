import 'package:flutter/material.dart';
import 'package:timetable_screen/timetable_screen.dart'; // Датаны форматтоо үчүн

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TimetableScreen());
  }
}
