import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AppServices {
  static final _supabase = Supabase.instance.client;
  static const String _mlUrl = 'https://smartparentassistant.vercel.app/api/analyze/';

  static User? get currentUser => _supabase.auth.currentUser;
  
  static Future<void> signUp(String email, String password) async => await _supabase.auth.signUp(email: email, password: password);
  static Future<void> signIn(String email, String password) async => await _supabase.auth.signInWithPassword(email: email, password: password);
  static Future<void> signOut() async => await _supabase.auth.signOut();

  // --- ML API ---
  static Future<Map<String, dynamic>> analyzeBehavior(List<double> features) async {
    try {
      final bodyData = {};
      for(int i=0; i<10; i++) bodyData['f${i+1}'] = features[i];
      final resp = await http.post(Uri.parse(_mlUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode(bodyData));
      if (resp.statusCode == 200) return jsonDecode(resp.body)['data'];
      return {'prediction': 'Analysis Error', 'confidence_percentage': 0.0};
    } catch (e) { return {'prediction': 'Network Offline', 'confidence_percentage': 0.0}; }
  }

  // --- DB LOGIC ---
  static Future<void> saveGrowth(double w, double h) async {
    if (currentUser != null) await _supabase.from('growth_records').insert({'user_id': currentUser!.id, 'weight': w, 'height': h});
  }
  static Future<List<dynamic>> getGrowthRecords() async => currentUser != null ? await _supabase.from('growth_records').select().eq('user_id', currentUser!.id).order('created_at', ascending: false) : [];

  static Future<String?> uploadPhoto() async {
    if (currentUser == null) return "Not logged in";
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (file == null) return null; // User canceled
      
      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last;
      final path = '${currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.$ext';
      
      await _supabase.storage.from('baby_photos').uploadBinary(path, bytes);
      final url = _supabase.storage.from('baby_photos').getPublicUrl(path);
      await _supabase.from('child_photos').insert({'user_id': currentUser!.id, 'image_url': url});
      return "Success";
    } catch (e) { return e.toString(); }
  }
  static Future<List<dynamic>> getPhotos() async => currentUser != null ? await _supabase.from('child_photos').select().eq('user_id', currentUser!.id).order('created_at', ascending: false) : [];
}

// --- LIVE TIMER STATE MANAGER ---
class TimerManager {
  static DateTime? targetTime;
  static void setTimer(int hours, int minutes) {
    targetTime = DateTime.now().add(Duration(hours: hours, minutes: minutes));
  }
  static void clearTimer() => targetTime = null;
}
