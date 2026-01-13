import 'package:flutter/material.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/child_info_screen.dart';
import 'screens/situation_screen.dart';
import 'screens/health_screen.dart';

void main() {
  runApp(const SmartParentAssistantApp());
}

class SmartParentAssistantApp extends StatelessWidget {
  const SmartParentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Parent Assistant',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),

      // First screen
      home: const HomeScreen(),

      // App routes
      routes: {
        '/child-info': (context) => const ChildInfoScreen(),
        '/situation': (context) => const SituationScreen(),
        '/health': (context) => const HealthScreen(),
      },
    );
  }
}
