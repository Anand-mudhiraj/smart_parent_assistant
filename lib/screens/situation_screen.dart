import 'package:flutter/material.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  String sleep = 'Well';
  String feeding = 'Less than 1 hour';

  void analyzeSituation() {
    String reason;
    List<String> suggestions = [];
    bool consultDoctor = false;

    // 🧠 RULE-BASED DECISION LOGIC
    if (sleep == 'Not well' && feeding == 'More than 2 hours') {
      reason = 'Possible hunger and fatigue';
      suggestions = [
        'Feed the child immediately',
        'Help the child rest in a calm place',
        'Observe if crying reduces after feeding'
      ];
    } else if (feeding == 'More than 2 hours') {
      reason = 'Possible hunger';
      suggestions = [
        'Feed the child',
        'Check feeding schedule',
        'Burp the child after feeding'
      ];
    } else if (sleep == 'Not well') {
      reason = 'Possible tiredness or discomfort';
      suggestions = [
        'Help the child sleep',
        'Reduce noise and light',
        'Comfort the child gently'
      ];
    } else {
      reason = 'General discomfort';
      suggestions = [
        'Check diaper condition',
        'Ensure comfortable clothing',
        'Hold and comfort the child'
      ];
    }

    Navigator.pushNamed(
      context,
      '/result',
      arguments: {
        'reason': reason,
        'suggestions': suggestions,
        'consultDoctor': consultDoctor,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Situation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Sleep Quality'),
                trailing: DropdownButton<String>(
                  value: sleep,
                  items: ['Well', 'Not well']
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => sleep = v!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('Last Feeding Time'),
                trailing: DropdownButton<String>(
                  value: feeding,
                  items: [
                    'Less than 1 hour',
                    '1–2 hours',
                    'More than 2 hours'
                  ]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => feeding = v!),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: analyzeSituation,
                child: const Text('Analyze'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
