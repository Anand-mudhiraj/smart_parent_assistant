import 'package:flutter/material.dart';
import 'child_info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parent Assistant"),
        backgroundColor: const Color(0xFF0F9D8F),
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Image.asset(
                  "assets/images/logo.png",
                  height: 120,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Understand Your Child Better",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D8F)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChildInfoScreen()));
                  },
                  child: const Text("Start"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}