import 'package:flutter/material.dart';
import 'situation_screen.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({super.key});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {

  String? ageGroup;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Child Information"),
        backgroundColor: const Color(0xFF0F9D8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            DropdownButtonFormField(
              hint: const Text("Age Group"),
              items: const [
                DropdownMenuItem(value: "0-6", child: Text("0-6 Months")),
                DropdownMenuItem(value: "6-12", child: Text("6-12 Months")),
                DropdownMenuItem(value: "1-2", child: Text("1-2 Years")),
              ],
              onChanged: (value) {
                ageGroup = value;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              hint: const Text("Gender"),
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              onChanged: (value) {
                gender = value;
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SituationScreen()));
              },
              child: const Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}