import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parent Assistant"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/child'); // ✅ NOW EXISTS
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 16,
            ),
          ),
          child: const Text(
            "Start",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}