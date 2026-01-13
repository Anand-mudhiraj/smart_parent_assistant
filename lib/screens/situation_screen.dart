import 'package:flutter/material.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  String? feedingTime;
  bool sleptWell = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Situation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Feeding Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('< 1 hour'),
              value: '<1',
              groupValue: feedingTime,
              onChanged: (v) => setState(() => feedingTime = v),
            ),
            RadioListTile<String>(
              title: const Text('1 - 3 hours'),
              value: '1-3',
              groupValue: feedingTime,
              onChanged: (v) => setState(() => feedingTime = v),
            ),
            RadioListTile<String>(
              title: const Text('> 3 hours'),
              value: '>3',
              groupValue: feedingTime,
              onChanged: (v) => setState(() => feedingTime = v),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text('Did the child sleep well?'),
              value: sleptWell,
              onChanged: (v) => setState(() => sleptWell = v),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: feedingTime != null
                    ? () {
                        Navigator.pushNamed(context, '/health');
                      }
                    : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
