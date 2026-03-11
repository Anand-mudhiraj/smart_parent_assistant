import 'package:flutter/material.dart';
import 'result_screen.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {

  String sleepQuality = "Sleeping well";
  String feedingGap = "Less than 1 hour";
  String cryingIntensity = "Mild";
  String visibleDiscomfort = "None";
  String bodyTemperature = "Normal";

  void analyzeSituation() {

    String result = "General Discomfort";

    if (feedingGap == "More than 3 hours") {
      result = "Hungry";
    }
    else if (sleepQuality == "Not sleeping") {
      result = "Sleepy";
    }
    else if (visibleDiscomfort == "Stomach tight / gas") {
      result = "Gas Pain";
    }
    else if (bodyTemperature == "Feels hot") {
      result = "Possible fever";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(reason: result),
      ),
    );
  }

  Widget dropdown(String title, String value, List<String> items, Function(String?) onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: title,
            border: InputBorder.none,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Situation"),
        backgroundColor: const Color(0xFF0F9D8F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            dropdown(
              "Sleep Quality",
              sleepQuality,
              ["Sleeping well","Light sleep","Not sleeping"],
                  (value){
                setState(() {
                  sleepQuality = value!;
                });
              },
            ),

            dropdown(
              "Last Feeding Time",
              feedingGap,
              ["Less than 1 hour","1–3 hours","More than 3 hours"],
                  (value){
                setState(() {
                  feedingGap = value!;
                });
              },
            ),

            dropdown(
              "Crying Intensity",
              cryingIntensity,
              ["Mild","Moderate","Continuous / loud"],
                  (value){
                setState(() {
                  cryingIntensity = value!;
                });
              },
            ),

            dropdown(
              "Visible Discomfort",
              visibleDiscomfort,
              ["None","Skin irritation / rash","Stomach tight / gas"],
                  (value){
                setState(() {
                  visibleDiscomfort = value!;
                });
              },
            ),

            dropdown(
              "Body Temperature",
              bodyTemperature,
              ["Normal","Feels hot","Feels cold"],
                  (value){
                setState(() {
                  bodyTemperature = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F9D8F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: analyzeSituation,
              icon: const Icon(Icons.analytics),
              label: const Text("Analyze"),
            )
          ],
        ),
      ),
    );
  }
}