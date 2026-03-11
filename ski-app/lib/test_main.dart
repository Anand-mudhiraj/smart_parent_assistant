import 'package:flutter/material.dart';
import 'services/ml_service.dart';

void main() => runApp(const MaterialApp(home: MLTestScreen()));

class MLTestScreen extends StatefulWidget {
  const MLTestScreen({super.key});
  @override
  State<MLTestScreen> createState() => _MLTestScreenState();
}

class _MLTestScreenState extends State<MLTestScreen> {
  String _result = "Press to test the Smart Mapping";
  bool _isLoading = false;

  void _runSmartTest() async {
    setState(() { _isLoading = true; _result = "?? Mapping & Sending..."; });
    try {
      // Testing with real-world parameters now!
      final data = await MLService().getSmartPrediction(
        childAge: 4, 
        situation: "Public", 
        parentStress: 8, 
        timeOfDay: "Night", 
        isFirstTime: true,
      );
      
      setState(() {
        _result = "? SMART RESULT!\n\nReason: ${data['prediction']}\nConfidence: ${data['confidence_percentage']}%";
      });
    } catch (e) {
      setState(() { _result = "? FAILED!\n\n$e"; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart ML Test'), backgroundColor: Colors.deepPurple),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          if (_isLoading) const CircularProgressIndicator() else ElevatedButton.icon(
            icon: const Icon(Icons.psychology),
            label: const Text('Test Mapping Logic'),
            onPressed: _runSmartTest,
          ),
        ]),
      )),
    );
  }
}
