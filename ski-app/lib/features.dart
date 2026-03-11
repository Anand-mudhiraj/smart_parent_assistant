import 'package:flutter/material.dart';
import 'services.dart';

// --- 1. AI ANALYZER (Flashcard UI) ---
class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});
  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isAnalyzing = false;
  final List<int> _answers = List.filled(10, 0);

  final List<Map<String, dynamic>> _q = [
    {"title": "Time of day?", "icon": Icons.access_time, "opts": ["Morning", "Afternoon", "Evening", "Night"]},
    {"title": "Sleep quality?", "icon": Icons.bedtime_outlined, "opts": ["Good", "Restless", "No Sleep"]},
    {"title": "Time since last feed?", "icon": Icons.restaurant_menu, "opts": ["< 1 hr", "1-3 hrs", "> 3 hrs"]},
    {"title": "Feeding behavior?", "icon": Icons.child_care, "opts": ["Normal", "Fussy", "Refusing to Eat"]},
    {"title": "Diaper status?", "icon": Icons.baby_changing_station, "opts": ["Recent", "1-3 hrs ago", "Needs Change"]},
    {"title": "Type of crying?", "icon": Icons.record_voice_over, "opts": ["Whimper", "Loud", "Screaming"]},
    {"title": "Physical signs?", "icon": Icons.touch_app_outlined, "opts": ["None", "Gas / Tense", "Skin Rash"]},
    {"title": "Body temperature?", "icon": Icons.thermostat, "opts": ["Normal", "Warm", "Hot / Feverish"]},
    {"title": "Breathing pattern?", "icon": Icons.air, "opts": ["Normal", "Stuffy", "Rapid / Wheezing"]},
    {"title": "Activity level?", "icon": Icons.directions_run, "opts": ["Active", "Fussy", "Lethargic / Limp"]},
  ];

  void _selectOption(int optIndex) async {
    _answers[_currentIndex] = optIndex;
    if (_currentIndex < 9) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      setState(() => _currentIndex++);
    } else {
      setState(() => _isAnalyzing = true);
      final result = await AppServices.analyzeBehavior(_answers.map((e) => e.toDouble()).toList());
      if (!mounted) return;
      _showResult(result['prediction'] ?? "Unknown", result['confidence_percentage'] ?? 0.0);
    }
  }

  void _showResult(String pred, double conf) {
    bool isUrgent = _answers[8] == 2 || _answers[9] == 2 || _answers[7] == 2 || pred.contains("Distress");
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: isUrgent ? const Color(0xFFFEF2F2) : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(isUrgent ? Icons.warning_rounded : Icons.check_circle, size: 60, color: isUrgent ? Colors.red : Colors.green),
          const SizedBox(height: 16),
          Text(pred, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isUrgent ? Colors.red : Colors.indigo)),
          const SizedBox(height: 16),
          Text(isUrgent ? "CRITICAL: Please contact a pediatrician immediately." : "Checklist: Ensure comfortable environment, check diaper, and offer a feeding if due.", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text("Done")))
        ]),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: (_currentIndex + 1) / 10, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)), minHeight: 8),
        ),
      ),
      body: _isAnalyzing 
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text("AI is analyzing...")])) 
        : PageView.builder(
            controller: _pageController, physics: const NeverScrollableScrollPhysics(), itemCount: 10,
            itemBuilder: (c, i) => Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Question ${i+1} of 10", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(_q[i]["title"], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 40),
                  ...List.generate(_q[i]["opts"].length, (idx) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(width: double.infinity, height: 70, child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      onPressed: () => _selectOption(idx), child: Text(_q[i]["opts"][idx], style: const TextStyle(fontSize: 18))
                    )),
                  ))
                ],
              ),
            ),
          ),
    );
  }
}

// --- 2. GROWTH TRACKER ---
class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});
  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final _w = TextEditingController();
  final _h = TextEditingController();

  void _addRecord() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text("Log Milestone", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _w, decoration: InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        TextField(controller: _h, decoration: InputDecoration(labelText: "Height (cm)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.number),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        FilledButton(onPressed: () async {
          await AppServices.saveGrowth(double.parse(_w.text), double.parse(_h.text));
          if(mounted) { Navigator.pop(context); setState((){}); }
        }, child: const Text("Save"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Growth Tracker", style: TextStyle(fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<dynamic>>(
        future: AppServices.getGrowthRecords(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text("No records yet. Tap + to add.", style: TextStyle(color: Colors.grey, fontSize: 16)));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (c, i) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFE0E7FF), child: Icon(Icons.straighten, color: Color(0xFF6366F1))),
                title: Text("${data[i]['weight']} kg  |  ${data[i]['height']} cm", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(data[i]['created_at'].toString().substring(0, 10)),
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _addRecord, icon: const Icon(Icons.add), label: const Text("Add Log")),
    );
  }
}

// --- 3. PHOTO JOURNAL ---
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _uploading = false;

  void _upload() async {
    setState(() => _uploading = true);
    await AppServices.uploadPhoto();
    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo Journal", style: TextStyle(fontWeight: FontWeight.bold))),
      body: _uploading ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text("Saving to Cloud...")])) : FutureBuilder<List<dynamic>>(
        future: AppServices.getPhotos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text("Capture a memory! Tap the camera.", style: TextStyle(color: Colors.grey, fontSize: 16)));
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: data.length,
            itemBuilder: (c, i) => ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(data[i]['image_url'], fit: BoxFit.cover)),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: _upload, child: const Icon(Icons.camera_alt)),
    );
  }
}
