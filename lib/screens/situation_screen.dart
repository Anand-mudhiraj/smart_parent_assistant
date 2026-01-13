import 'package:flutter/material.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  String sleep = 'Sleeping well';
  String feedingTime = 'Less than 1 hour';
  String crying = 'Mild';
  String discomfort = 'None';
  String temperature = 'Normal';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String age = args['age'];

    return Scaffold(
      appBar: AppBar(title: const Text('Current Situation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(
              label: 'Sleep Quality',
              value: sleep,
              items: const [
                'Sleeping well',
                'Light sleep',
                'Not sleeping',
              ],
              onChanged: (v) => setState(() => sleep = v),
            ),
            _buildDropdown(
              label: 'Last Feeding Time',
              value: feedingTime,
              items: const [
                'Less than 1 hour',
                '1–3 hours',
                'More than 3 hours',
              ],
              onChanged: (v) => setState(() => feedingTime = v),
            ),
            _buildDropdown(
              label: 'Crying Intensity',
              value: crying,
              items: const [
                'Mild',
                'Moderate',
                'Continuous / loud',
              ],
              onChanged: (v) => setState(() => crying = v),
            ),
            _buildDropdown(
              label: 'Visible Discomfort',
              value: discomfort,
              items: const [
                'None',
                'Pulling ears',
                'Stomach tight / gas',
                'Skin irritation / rash',
              ],
              onChanged: (v) => setState(() => discomfort = v),
            ),
            _buildDropdown(
              label: 'Body Temperature (Touch)',
              value: temperature,
              items: const [
                'Normal',
                'Feels warm',
                'Feels hot',
              ],
              onChanged: (v) => setState(() => temperature = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics),
                label: const Text('Analyze'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/result',
                    arguments: {
                      'age': age,
                      'sleep': sleep,
                      'feedingTime': feedingTime,
                      'crying': crying,
                      'discomfort': discomfort,
                      'temperature': temperature,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}
