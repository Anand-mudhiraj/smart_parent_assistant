import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check'),
      ),
      body: const Center(
        child: Text(
          'Health indicators screen (Coming soon)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
