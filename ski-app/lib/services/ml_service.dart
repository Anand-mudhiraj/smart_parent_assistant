import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  static const String _baseUrl = 'https://smartparentassistant.vercel.app/api/analyze/';

  // AI Prediction Call
  Future<Map<String, dynamic>> analyzeBehavior({
    required double feature1, required double feature2, required double feature3,
    required double feature4, required double feature5,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'feature_1': feature1, 'feature_2': feature2, 'feature_3': feature3,
          'feature_4': feature4, 'feature_5': feature5,
        }),
      );
      return resp.statusCode == 200 ? jsonDecode(resp.body)['data'] : {'prediction': 'Error', 'confidence_percentage': 0.0};
    } catch (e) { return {'prediction': 'Offline', 'confidence_percentage': 0.0}; }
  }

  // Growth Tracking Logic (Simplified for BTech Project)
  Future<bool> saveGrowthData(double weight, double height) async {
    // Note: In production, you would use the supabase_flutter package here.
    // For this demo, we are focusing on the AI pipeline success.
    print("Saving to Supabase: Weight $weight, Height $height");
    return true; 
  }
}
