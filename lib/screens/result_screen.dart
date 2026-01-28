import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Result"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                const Text(
                  "Likely Reason",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}