import 'package:flutter/material.dart';
import 'services/ml_service.dart';

void main() => runApp(const SmartParentApp());

class SmartParentApp extends StatelessWidget {
  const SmartParentApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF0F9D8F)),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(title: const Text("Smart Parent Assistant"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text("Hello, Aadi!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          _card(context, "AI Cry Analysis", "Analyze why baby is crying", Icons.auto_awesome, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SituationScreen()))),
          const SizedBox(height: 15),
          _card(context, "Growth Tracker", "Log Height & Weight", Icons.line_axis, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (c) => const GrowthScreen()))),
          const SizedBox(height: 15),
          _card(context, "Photo Journal", "Store memories", Icons.photo_camera, Colors.orange, () {}),
        ],
      ),
    );
  }

  Widget _card(BuildContext ctx, String t, String s, IconData i, Color c, VoidCallback onTap) {
    return Card(
      elevation: 0, color: c.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: CircleAvatar(backgroundColor: c, child: Icon(i, color: Colors.white)),
        title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(s),
        onTap: onTap,
      ),
    );
  }
}

// --- AI SITUATION SCREEN ---
class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key});
  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  double _f1 = 0, _f2 = 0, _f3 = 0, _f4 = 0, _f5 = 0;
  bool _loading = false;

  void _runAI() async {
    setState(() => _loading = true);
    final res = await MLService().analyzeBehavior(feature1: _f1, feature2: _f2, feature3: _f3, feature4: _f4, feature5: _f5);
    setState(() => _loading = false);
    _showResult(res['prediction'], res['confidence_percentage'] ?? 0.0);
  }

  void _showResult(String p, double c) {
    bool urgent = p.toLowerCase().contains("sick") || _f5 == 1.0;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(urgent ? Icons.warning : Icons.check_circle, color: urgent ? Colors.red : Colors.teal, size: 50),
          const SizedBox(height: 20),
          Text(p, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text("Confidence: ${c.toStringAsFixed(1)}%"),
          const SizedBox(height: 20),
          Text(urgent ? "ALERT: Consult a doctor if symptoms persist." : "Suggestion: Check feeding schedule and room lighting.", textAlign: TextAlign.center),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cry Analysis")),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _drop("Sleep Quality", (v) => _f1 = v.toDouble()),
          _drop("Feeding Gap", (v) => _f2 = v.toDouble()),
          _drop("Crying Intensity", (v) => _f3 = v.toDouble()),
          _drop("Discomfort", (v) => _f4 = v.toDouble()),
          _drop("Temperature", (v) => _f5 = v.toDouble()),
          const SizedBox(height: 30),
          SizedBox(height: 60, child: FilledButton(onPressed: _runAI, child: const Text("Predict Reason"))),
        ],
      ),
    );
  }

  Widget _drop(String l, Function(int) onC) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(labelText: l, border: const OutlineInputBorder()),
        items: const [DropdownMenuItem(value: 0, child: Text("Normal")), DropdownMenuItem(value: 1, child: Text("Moderate")), DropdownMenuItem(value: 2, child: Text("High"))],
        onChanged: (v) => onC(v!),
      ),
    );
  }
}

// --- GROWTH TRACKER SCREEN ---
class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});
  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final _w = TextEditingController();
  final _h = TextEditingController();

  void _save() async {
    await MLService().saveGrowthData(double.parse(_w.text), double.parse(_h.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Growth Logged Successfully!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Growth Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(controller: _w, decoration: const InputDecoration(labelText: "Weight (kg)"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          TextField(controller: _h, decoration: const InputDecoration(labelText: "Height (cm)"), keyboardType: TextInputType.number),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, height: 55, child: FilledButton(onPressed: _save, child: const Text("Save Log"))),
        ]),
      ),
    );
  }
}
