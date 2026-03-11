Write-Host "Fixing Smart Parent Assistant Project..."

$base = "C:\Users\anand\smart_parent_assistant\ski-app\lib"

# Create missing folders
New-Item -ItemType Directory -Force "$base\models"
New-Item -ItemType Directory -Force "$base\services"
New-Item -ItemType Directory -Force "$base\widgets"

# =============================
# Child Data Model
# =============================

@"
class ChildData {
  final int sleepQuality;
  final int feedingGap;
  final int cryingIntensity;
  final int discomfort;
  final int temperature;

  ChildData({
    required this.sleepQuality,
    required this.feedingGap,
    required this.cryingIntensity,
    required this.discomfort,
    required this.temperature,
  });

  Map<String, dynamic> toJson() {
    return {
      "feature_1": sleepQuality,
      "feature_2": feedingGap,
      "feature_3": cryingIntensity,
      "feature_4": discomfort,
      "feature_5": temperature,
    };
  }
}
"@ | Set-Content "$base\models\child_data_model.dart"

# =============================
# Auth Service
# =============================

@"
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase = Supabase.instance.client;

  Future signIn(String email, String password) async {

    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return res.user;

  }

  Future signUp(String email, String password) async {

    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    return res.user;

  }

  Future signOut() async {

    await supabase.auth.signOut();

  }
}
"@ | Set-Content "$base\services\auth_service.dart"

# =============================
# Supabase Service
# =============================

@"
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
"@ | Set-Content "$base\services\supabase_service.dart"

# =============================
# Growth Tracker Screen
# =============================

@"
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class GrowthTrackerScreen extends StatefulWidget {
  const GrowthTrackerScreen({super.key});

  @override
  State<GrowthTrackerScreen> createState() => _GrowthTrackerScreenState();
}

class _GrowthTrackerScreenState extends State<GrowthTrackerScreen> {

  final weight = TextEditingController();
  final height = TextEditingController();

  final service = SupabaseService();

  void save() async {

    await service.saveGrowth(
      double.parse(weight.text),
      double.parse(height.text),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Growth Saved")));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Growth Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: weight,
              decoration: const InputDecoration(labelText: "Weight"),
            ),

            TextField(
              controller: height,
              decoration: const InputDecoration(labelText: "Height"),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Save"),
            )

          ],
        ),
      ),
    );

  }
}
"@ | Set-Content "$base\screens\growth_tracker_screen.dart"

# =============================
# Photo Gallery
# =============================

@"
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {

  File? image;

  pickImage() async {

    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(file != null){

      setState(() {
        image = File(file.path);
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Child Photos")),

      body: Column(
        children: [

          ElevatedButton(
            onPressed: pickImage,
            child: const Text("Upload Photo"),
          ),

          if(image != null)
            Image.file(image!,height:200)

        ],
      ),
    );
  }
}
"@ | Set-Content "$base\screens\photo_gallery_screen.dart"

Write-Host "Project Fix Completed"