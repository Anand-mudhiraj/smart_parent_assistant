import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/child_info_screen.dart';
import 'screens/situation_screen.dart';
import 'services/ml_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MLService.loadModel();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parent Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/child': (context) => const ChildInfoScreen(),
        '/situation': (context) => const SituationScreen(),
        // ❌ NO '/result' HERE
      },
    );
  }
}