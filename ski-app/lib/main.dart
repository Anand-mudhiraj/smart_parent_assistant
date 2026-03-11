import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SmartParentAssistant());
}

class SmartParentAssistant extends StatelessWidget {
  const SmartParentAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parent Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0F9D8F),
        scaffoldBackgroundColor: const Color(0xFFF4F6F6),
      ),
      home: const LoginScreen(),
    );
  }
}