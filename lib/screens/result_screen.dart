import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String reason = args['reason'];
    final List<String> suggestions =
        List<String>.from(args['suggestions']);
    final bool consultDoctor = args['consultDoctor'] == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 Reason
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.psychology, color: Colors.teal, size: 36),
                title: Text(
                  reason,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Suggestions
            const Text(
              'Suggested Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...suggestions.map(
              (s) => Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(s),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🚨 DOCTOR ALERT (THIS WAS MISSING / BROKEN)
            if (consultDoctor)
              Card(
                color: Colors.red.shade50,
                child: const ListTile(
                  leading: Icon(Icons.warning,
                      color: Colors.red, size: 36),
                  title: Text(
                    'If the condition continues, please consult a pediatrician.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // 🏠 Back button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
