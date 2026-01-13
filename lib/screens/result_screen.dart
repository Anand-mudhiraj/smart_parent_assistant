import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;

    final String age = data['age'];
    final String sleep = data['sleep'];
    final String feedingTime = data['feedingTime'];
    final String crying = data['crying'];
    final String discomfort = data['discomfort'];
    final String temperature = data['temperature'];

    List<String> suggestions = [];
    bool doctorAlert = false;
    String possibleReason = '';

    // ---------------- RULE-BASED ANALYSIS ----------------

    // CASE 1: Hunger-related
    if (feedingTime == 'More than 3 hours') {
      possibleReason = 'Possible hunger';
      suggestions.addAll([
        'Feed the child immediately',
        'Help the child rest in a calm place',
        'Observe if crying reduces after feeding',
      ]);

      if (age == '0-6') {
        doctorAlert = true;
      }
    }

    // CASE 2: Sleep-related discomfort
    else if (sleep == 'Not sleeping' && crying != 'Mild') {
      possibleReason = 'Sleep discomfort or overtiredness';
      suggestions.addAll([
        'Create a quiet and dim environment',
        'Rock or gently soothe the child',
        'Maintain a consistent sleep routine',
      ]);
    }

    // CASE 3: Temperature concern
    else if (temperature == 'Feels hot') {
      possibleReason = 'Possible fever';
      suggestions.addAll([
        'Remove excess clothing',
        'Keep the child hydrated',
        'Monitor body temperature closely',
      ]);
      doctorAlert = true;
    }

    // CASE 4: Physical discomfort
    else if (discomfort != 'None') {
      possibleReason = 'Physical discomfort';
      suggestions.addAll([
        'Check diaper and clothing comfort',
        'Gently massage or comfort the child',
        'Observe for visible irritation or pain',
      ]);

      if (discomfort == 'Pulling ears') {
        doctorAlert = true;
      }
    }

    // CASE 5: Continuous crying
    else if (crying == 'Continuous / loud') {
      possibleReason = 'General distress';
      suggestions.addAll([
        'Hold the child close and comfort them',
        'Check for any unnoticed discomfort',
        'Try calming sounds or gentle movement',
      ]);
    }

    // DEFAULT SAFE CASE
    else {
      possibleReason = 'General discomfort';
      suggestions.addAll([
        'Check diaper condition',
        'Ensure comfortable clothing',
        'Hold and comfort the child',
      ]);
    }

    // ----------------------------------------------------

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Possible reason
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.teal),
                title: const Text(
                  'Possible Reason',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(possibleReason),
              ),
            ),

            const SizedBox(height: 16),

            // Doctor alert
            if (doctorAlert)
              Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text(
                    'Doctor Consultation Recommended',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    'Please consult a pediatrician if symptoms persist.',
                  ),
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              'Suggested Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Suggestions list
            ...suggestions.map(
              (s) => Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(s),
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/health');
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
