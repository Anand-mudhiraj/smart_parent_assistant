import 'package:flutter/material.dart';
import '../services/ml_service.dart';
import 'result_screen.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  String sleepQuality = "Sleeping well";
  String feedingTime = "Less than 1 hour";
  String crying = "Mild";
  String discomfort = "None";
  String temperature = "Normal";

  bool isLoading = false;

  Future<void> analyze() async {
    setState(() => isLoading = true);

    try {
      final result = MLService.predict(
        ageGroup: 1,
        feedingGap: feedingTime == "Less than 1 hour" ? 0 : 2,
        sleepOk: sleepQuality == "Sleeping well" ? 1 : 0,
        cryLevel: crying == "Mild"
            ? 1
            : crying == "Medium"
                ? 2
                : 3,
        discomfort: discomfort == "None" ? 0 : 1,
        temp: temperature == "Normal" ? 0 : 1,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Analysis failed")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Situation"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _dropdown("Sleep Quality", sleepQuality,
                ["Sleeping well", "Not sleeping well"],
                (v) => setState(() => sleepQuality = v)),

            _dropdown("Last Feeding Time", feedingTime,
                ["Less than 1 hour", "1 - 2 hours", "More than 2 hours"],
                (v) => setState(() => feedingTime = v)),

            _dropdown("Crying Intensity", crying,
                ["Mild", "Medium", "High"],
                (v) => setState(() => crying = v)),

            _dropdown("Visible Discomfort", discomfort,
                ["None", "Yes"],
                (v) => setState(() => discomfort = v)),

            _dropdown("Body Temperature", temperature,
                ["Normal", "High"],
                (v) => setState(() => temperature = v)),

            const SizedBox(height: 30),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: analyze,
                    icon: const Icon(Icons.analytics),
                    label: const Text("Analyze"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}