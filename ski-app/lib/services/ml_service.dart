import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  static const String _baseUrl = 'https://smartparentassistant.vercel.app/api/analyze/';

  Future<Map<String, dynamic>> analyzeBehavior(List<double> features) async {
    try {
      final bodyData = {};
      for(int i=0; i<10; i++) bodyData['f${i+1}'] = features[i];

      final resp = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );
      if (resp.statusCode == 200) return jsonDecode(resp.body)['data'];
      return {'prediction': 'Server Error', 'confidence_percentage': 0.0};
    } catch (e) {
      return {'prediction': 'Offline', 'confidence_percentage': 0.0};
    }
  }
}
