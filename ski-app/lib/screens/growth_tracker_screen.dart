import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class GrowthTrackerScreen extends StatefulWidget {
  const GrowthTrackerScreen({super.key});

  @override
  State<GrowthTrackerScreen> createState() => _GrowthTrackerScreenState();
}

class _GrowthTrackerScreenState extends State<GrowthTrackerScreen> {

  final weight = TextEditingController();
  final height = TextEditingController();

  final service = SupabaseService();

  void save() async {

    await service.saveGrowth(
      double.parse(weight.text),
      double.parse(height.text),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Growth Saved")));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Growth Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: weight,
              decoration: const InputDecoration(labelText: "Weight"),
            ),

            TextField(
              controller: height,
              decoration: const InputDecoration(labelText: "Height"),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Save"),
            )

          ],
        ),
      ),
    );

  }
}
