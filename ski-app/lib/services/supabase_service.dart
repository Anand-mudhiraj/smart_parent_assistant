import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  final supabase = Supabase.instance.client;

  Future savePrediction(String reason, double confidence) async {

    await supabase.from('prediction_history').insert({
      "reason": reason,
      "confidence": confidence,
      "created_at": DateTime.now().toIso8601String()
    });

  }

  Future saveGrowth(double weight, double height) async {

    await supabase.from('growth_records').insert({
      "weight": weight,
      "height": height,
      "date": DateTime.now().toIso8601String()
    });

  }
}
