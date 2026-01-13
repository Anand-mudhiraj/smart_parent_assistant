import 'package:flutter/material.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({super.key});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  String? age;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Age Group',
                    border: OutlineInputBorder(),
                  ),
                  value: age,
                  items: const [
                    DropdownMenuItem(value: '0-6', child: Text('0–6 Months')),
                    DropdownMenuItem(value: '6-12', child: Text('6–12 Months')),
                    DropdownMenuItem(value: '1-3', child: Text('1–3 Years')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      age = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: gender,
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue'),
                    onPressed: age != null && gender != null
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/situation',
                              arguments: {
                                'age': age,
                                'gender': gender,
                              },
                            );
                          }
                        : null,
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
