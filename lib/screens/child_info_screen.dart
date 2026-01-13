import 'package:flutter/material.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({super.key});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  String? age;
  String? gender;

  final ageGroups = [
    '0–6 months',
    '6–12 months',
    '1–3 years',
    '3–5 years'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Select age group'),
                  value: age,
                  items: ageGroups
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => age = value),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  RadioListTile(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v),
                  ),
                  RadioListTile(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (age != null && gender != null)
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/situation',
                          arguments: {'age': age, 'gender': gender},
                        );
                      }
                    : null,
                child: const Text('Continue'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
