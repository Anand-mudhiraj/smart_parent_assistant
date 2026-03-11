import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AppServices {
  static final _supabase = Supabase.instance.client;
  static const String _mlUrl = 'https://smartparentassistant.vercel.app/api/analyze/';

  // --- AUTHENTICATION ---
  static User? get currentUser => _supabase.auth.currentUser;
  
  static Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  static Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // --- ML PREDICTION ---
  static Future<Map<String, dynamic>> analyzeBehavior(List<double> features) async {
    try {
      final bodyData = {};
      for(int i=0; i<10; i++) bodyData['f${i+1}'] = features[i];
      final resp = await http.post(Uri.parse(_mlUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode(bodyData));
      if (resp.statusCode == 200) return jsonDecode(resp.body)['data'];
      return {'prediction': 'Server Error', 'confidence_percentage': 0.0};
    } catch (e) {
      return {'prediction': 'Offline', 'confidence_percentage': 0.0};
    }
  }

  // --- GROWTH TRACKER ---
  static Future<void> saveGrowth(double w, double h) async {
    if (currentUser == null) return;
    await _supabase.from('growth_records').insert({'user_id': currentUser!.id, 'weight': w, 'height': h});
  }

  static Future<List<dynamic>> getGrowthRecords() async {
    if (currentUser == null) return [];
    return await _supabase.from('growth_records').select().eq('user_id', currentUser!.id).order('created_at', ascending: false);
  }

  // --- PHOTO JOURNAL ---
  static Future<void> uploadPhoto() async {
    if (currentUser == null) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '${currentUser!.id}/$fileName';

    await _supabase.storage.from('baby_photos').uploadBinary(filePath, bytes);
    final imageUrl = _supabase.storage.from('baby_photos').getPublicUrl(filePath);
    await _supabase.from('child_photos').insert({'user_id': currentUser!.id, 'image_url': imageUrl});
  }

  static Future<List<dynamic>> getPhotos() async {
    if (currentUser == null) return [];
    return await _supabase.from('child_photos').select().eq('user_id', currentUser!.id).order('created_at', ascending: false);
  }
}
