import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'services.dart';

// ------------------------------------------------------------------
// 1. CATCHY "FLASHCARD" ANALYZER 
// ------------------------------------------------------------------
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
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ResultScreen(
          prediction: result['prediction'] ?? "Unknown", 
          confidence: result['confidence_percentage'] ?? 0.0,
          isUrgent: _answers[8] == 2 || _answers[9] == 2 || _answers[7] == 2 || (result['prediction'] ?? "").contains("Distress"),
        )
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / 10,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            minHeight: 8,
          ),
        ),
      ),
      body: _isAnalyzing 
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CupertinoActivityIndicator(radius: 20), SizedBox(height: 24), Text("Consulting AI Model...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))])) 
        : PageView.builder(
            controller: _pageController, physics: const NeverScrollableScrollPhysics(), itemCount: 10,
            itemBuilder: (c, i) => Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(24)), child: Icon(_q[i]["icon"], size: 40, color: const Color(0xFF2563EB))),
                  const SizedBox(height: 32),
                  Text(_q[i]["title"], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(height: 40),
                  ...List.generate(_q[i]["opts"].length, (idx) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity, height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2563EB), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5))),
                        onPressed: () => _selectOption(idx), 
                        child: Text(_q[i]["opts"][idx], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
    );
  }
}

// ------------------------------------------------------------------
// 2. DIAGNOSTIC REPORT (Startup Grade Result Screen)
// ------------------------------------------------------------------
class ResultScreen extends StatelessWidget {
  final String prediction;
  final double confidence;
  final bool isUrgent;
  const ResultScreen({super.key, required this.prediction, required this.confidence, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    Color primary = isUrgent ? const Color(0xFFE11D48) : const Color(0xFF2563EB);
    Color bg = isUrgent ? const Color(0xFFFFF1F2) : const Color(0xFFEFF6FF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false, title: const Text("Assessment Report", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24), border: Border.all(color: primary.withOpacity(0.2))),
              child: Column(
                children: [
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primary.withOpacity(0.2), blurRadius: 20)]), child: Icon(isUrgent ? Icons.medical_services : Icons.verified_user, size: 40, color: primary)),
                  const SizedBox(height: 24),
                  const Text("PRIMARY ASSESSMENT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text(prediction, textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: primary, height: 1.2)),
                  const SizedBox(height: 16),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text("Confidence: ${confidence.toStringAsFixed(1)}%", style: TextStyle(fontWeight: FontWeight.bold, color: primary, fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (isUrgent) ...[
              Container(
                padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFECACA))),
                child: const Row(children: [
                  Icon(Icons.warning_rounded, color: Color(0xFFE11D48), size: 30), SizedBox(width: 16),
                  Expanded(child: Text("Seek medical attention immediately. Do not administer medication without consulting a doctor.", style: TextStyle(color: Color(0xFF9F1239), fontWeight: FontWeight.w600, fontSize: 14, height: 1.4))),
                ]),
              ),
              const SizedBox(height: 32),
            ],
            const Text("Recommended Care Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            ..._getPlan(prediction, isUrgent).map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 22), const SizedBox(width: 16),
                Expanded(child: Text(step, style: const TextStyle(fontSize: 15, color: Color(0xFF334155), height: 1.5, fontWeight: FontWeight.w500))),
              ]),
            )),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 56, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: () => Navigator.pop(context), child: const Text("Return to Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
          ],
        ),
      ),
    );
  }

  List<String> _getPlan(String p, bool u) {
    if (u) return ["Monitor vitals closely.", "Keep airway clear.", "Contact emergency services or your pediatrician."];
    if (p.contains("Hungry")) return ["Prepare feeding.", "Check latching.", "Burp halfway."];
    if (p.contains("Gas")) return ["Bicycle legs.", "Massage tummy.", "Hold upright."];
    return ["Ensure clean diaper.", "Dim room lights.", "Try swaddling or skin-to-skin."];
  }
}

// ------------------------------------------------------------------
// 3. GROWTH TRACKER
// ------------------------------------------------------------------
class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});
  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}
class _GrowthScreenState extends State<GrowthScreen> {
  void _add() {
    final w = TextEditingController(), h = TextEditingController();
    showCupertinoModalPopup(context: context, builder: (_) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Log Milestone", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CupertinoTextField(controller: w, placeholder: "Weight (kg)", keyboardType: TextInputType.number, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 12),
          CupertinoTextField(controller: h, placeholder: "Height (cm)", keyboardType: TextInputType.number, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () async { await AppServices.saveGrowth(double.parse(w.text), double.parse(h.text)); if(mounted){Navigator.pop(context); setState((){});} }, style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Save Record", style: TextStyle(fontWeight: FontWeight.bold)))),
          const SizedBox(height: 16),
        ]),
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Growth Logs", style: TextStyle(fontSize: 16, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: FutureBuilder<List<dynamic>>(
        future: AppServices.getGrowthRecords(),
        builder: (c, snap) {
          if (!snap.hasData) return const Center(child: CupertinoActivityIndicator());
          if (snap.data!.isEmpty) return const Center(child: Text("No records found.", style: TextStyle(color: Colors.grey)));
          return ListView.builder(
            padding: const EdgeInsets.all(20), itemCount: snap.data!.length,
            itemBuilder: (c, i) => Container(
              margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.straighten, color: Color(0xFF3B82F6))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("${snap.data![i]['weight']} kg  •  ${snap.data![i]['height']} cm", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(snap.data![i]['created_at'].toString().substring(0, 10), style: const TextStyle(color: Colors.grey, fontSize: 13))])),
              ]),
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: _add, backgroundColor: const Color(0xFF0F172A), child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}

// ------------------------------------------------------------------
// 4. PHOTO JOURNAL
// ------------------------------------------------------------------
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}
class _GalleryScreenState extends State<GalleryScreen> {
  bool _up = false;
  void _upload() async {
    setState(() => _up = true);
    String? status = await AppServices.uploadPhoto();
    setState(() => _up = false);
    if (status != null && status != "Success" && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $status\nCheck Supabase Storage RLS!", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Memories", style: TextStyle(fontSize: 16, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: _up ? const Center(child: CupertinoActivityIndicator()) : FutureBuilder<List<dynamic>>(
        future: AppServices.getPhotos(),
        builder: (c, snap) {
          if (!snap.hasData) return const Center(child: CupertinoActivityIndicator());
          if (snap.data!.isEmpty) return const Center(child: Text("No memories yet.", style: TextStyle(color: Colors.grey)));
          return GridView.builder(
            padding: const EdgeInsets.all(16), itemCount: snap.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8),
            itemBuilder: (c, i) => ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(snap.data![i]['image_url'], fit: BoxFit.cover)),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: _upload, backgroundColor: const Color(0xFF0F172A), child: const Icon(Icons.add_a_photo, color: Colors.white)),
    );
  }
}

// ------------------------------------------------------------------
// 5. LIVE TIMER SCREEN (Fixed BuildContext bug!)
// ------------------------------------------------------------------
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Feed Reminder", style: TextStyle(fontSize: 16, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Icon(Icons.timer_outlined, size: 80, color: Color(0xFF3B82F6)),
          const SizedBox(height: 24),
          const Text("When is the next feeding?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _timeBtn(context, "In 2 Hours", 2),
          const SizedBox(height: 16),
          _timeBtn(context, "In 3 Hours", 3),
          const SizedBox(height: 16),
          _timeBtn(context, "In 4 Hours", 4),
          const Spacer(),
          TextButton(
            onPressed: () { TimerManager.clearTimer(); Navigator.pop(context); }, 
            child: const Text("Clear Active Timer", style: TextStyle(color: Colors.red))
          ),
        ]),
      ),
    );
  }

  // Notice: Navigator.pop(c) correctly uses the BuildContext 'c' passed to this function
  Widget _timeBtn(BuildContext c, String t, int h) => SizedBox(
    width: double.infinity, height: 60, 
    child: FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0F172A), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0)))), 
      onPressed: () { TimerManager.setTimer(h, 0); Navigator.pop(c); }, 
      child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
    )
  );
}
