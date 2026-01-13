import 'package:flutter/material.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  String sleep = 'Well';
  String feeding = 'Less than 1 hour';

  String ageGroup = ''; // ✅ stored safely

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ageGroup = args['age']; // ✅ guaranteed once
  }

  void analyzeSituation() {
    String reason;
    List<String> suggestions = [];
    bool consultDoctor = false;

    // 🧠 AGE-AWARE RULE-BASED LOGIC
    if (sleep == 'Not well' && feeding == 'More than 2 hours') {
      reason = 'Possible hunger and fatigue';

      if (ageGroup == '0–6 months') {
        suggestions = [
          'Feed the child immediately',
          'Help the child rest in a calm place',
          'Monitor crying closely after feeding',
        ];
        consultDoctor = true;
      } else {
        suggestions = [
          'Offer food or milk',
          'Ensure proper rest',
          'Engage the child calmly and observe behavior',
        ];
      }
    } else if (feeding == 'More than 2 hours') {
      reason = 'Possible hunger';
      suggestions = [
        'Feed the child',
        'Check feeding schedule',
        'Burp the child after feeding',
      ];
    } else if (sleep == 'Not well') {
      reason = 'Possible tiredness or discomfort';
      suggestions = [
        'Help the child sleep',
        'Reduce noise and light',
        'Comfort the child gently',
      ];
    } else {
      reason = 'General discomfort';
      suggestions = [
        'Check diaper condition',
        'Ensure comfortable clothing',
        'Hold and comfort the child',
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
            ),
          ],
        ),
      ),
    );
  }
}
