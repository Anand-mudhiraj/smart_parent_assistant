import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  // IMPORTANT: 
  // - Use '10.0.2.2' if testing on an Android Emulator.
  // - Use your computer's local IP (e.g., '192.168.1.x') if testing on a physical phone.
  // - We will swap this out for the Vercel URL once we deploy!
  static const String _baseUrl = 'http://127.0.0.1:8000/api/analyze/';

  Future<Map<String, dynamic>> analyzeBehavior({
    required double feature1,
    required double feature2,
    required double feature3,
    required double feature4,
    required double feature5,
  }) async {
    try {
      // 1. Prepare the exact features the Django API expects
      final Map<String, dynamic> requestData = {
        'f1': feature1,
        'f2': feature2,
        'f3': feature3,
        'f4': feature4,
        'f5': feature5,
      };

      // 2. Send the POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      // 3. Parse the prediction result
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data']; 
        // This will return: { 'prediction': '...', 'confidence_percentage': 99.9, 'class_id': 5 }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('ML API Error: $e');
      return {
        'prediction': 'Unable to analyze at this time.',
        'confidence_percentage': 0.0,
        'class_id': -1,
      };
    }
  }
}