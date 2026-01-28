import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  static late Interpreter _interpreter;
  static late List<String> _labels;
  static bool _loaded = false;

  // 🔹 Load model + labels
  static Future<void> loadModel() async {
    if (_loaded) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/ml/child_reason.tflite',
    );

    final labelsData =
        await rootBundle.loadString('assets/ml/labels.txt');

    _labels = labelsData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    print("MODEL INPUT SHAPE: ${_interpreter.getInputTensor(0).shape}");
    print("MODEL OUTPUT SHAPE: ${_interpreter.getOutputTensor(0).shape}");
    print("LABELS: $_labels");

    _loaded = true;
  }

  // 🔹 Predict
  static String predict({
    required int ageGroup,
    required int feedingGap,
    required int sleepOk,
    required int cryLevel,
    required int discomfort,
    required int temp,
  }) {
    // ✅ SAME NORMALIZATION AS PYTHON
    final input = Float32List.fromList([
      ageGroup / 2.0,     // ageGroup
      feedingGap / 2.0,   // feedingGap
      sleepOk.toDouble(), // already 0/1
      cryLevel / 3.0,     // cryLevel
      discomfort.toDouble(),
      temp.toDouble(),
    ]);

    final output =
        List.generate(1, (_) => List.filled(_labels.length, 0.0));

    print("INPUT (normalized): $input");

    _interpreter.run(input.reshape([1, 6]), output);

    print("RAW OUTPUT: ${output[0]}");

    final scores = output[0];
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final index = scores.indexOf(maxScore);

    return _labels[index];
  }
}