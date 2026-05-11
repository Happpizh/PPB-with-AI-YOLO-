import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOLO Tree Detector',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal, 
          secondary: Colors.greenAccent
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}