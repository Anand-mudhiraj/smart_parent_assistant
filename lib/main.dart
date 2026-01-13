import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/child_info_screen.dart';
import 'screens/situation_screen.dart';
import 'screens/result_screen.dart';
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/child-info': (context) => const ChildInfoScreen(),
        '/situation': (context) => const SituationScreen(),
        '/result': (context) => const ResultScreen(),
        '/health': (context) => const HealthScreen(),
      },
    );
  }
}
