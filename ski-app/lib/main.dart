import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features.dart';
import 'services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SECURE CREDENTIALS INJECTED HERE
  await Supabase.initialize(
    url: 'https://vqhyssgbickiexkxgcqn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxaHlzc2diaWNraWV4a3hnY3FuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNDc0MTAsImV4cCI6MjA4ODgyMzQxMH0.BP4_h6FozzGFZ1gCmgNyCVutlneK3hvzMdTP-4f1yaI',
  );
  
  runApp(const FullAssistantApp());
}

class FullAssistantApp extends StatelessWidget {
  const FullAssistantApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Segoe UI', colorSchemeSeed: const Color(0xFF6366F1)),
      home: const AuthWrapper(),
    );
  }
}

// --- AUTH WRAPPER ---
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppServices.currentUser == null ? const AuthScreen() : const Dashboard();
  }
}

// --- LOGIN / REGISTER SCREEN ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;

  void _submit() async {
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await AppServices.signIn(_email.text, _pass.text);
      } else {
        await AppServices.signUp(_email.text, _pass.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.child_care, size: 80, color: Color(0xFF6366F1)),
              const SizedBox(height: 24),
              Text(_isLogin ? "Welcome Back" : "Create Account", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(controller: _email, decoration: InputDecoration(labelText: "Email", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              TextField(controller: _pass, obscureText: true, decoration: InputDecoration(labelText: "Password", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
              const SizedBox(height: 32),
              _loading ? const CircularProgressIndicator() : SizedBox(
                width: double.infinity, height: 55,
                child: FilledButton(style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _submit, child: Text(_isLogin ? "Login" : "Sign Up", style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () => setState(() => _isLogin = !_isLogin), child: Text(_isLogin ? "Need an account? Sign Up" : "Have an account? Login", style: const TextStyle(color: Color(0xFF6366F1))))
            ],
          ),
        ),
      ),
    );
  }
}

// --- MAIN DASHBOARD ---
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    String emailPrefix = AppServices.currentUser?.email?.split('@')[0] ?? "Parent";
    String displayName = emailPrefix[0].toUpperCase() + emailPrefix.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Assistant", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => AppServices.signOut())],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $displayName", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const Text("What would you like to do today?", style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 32),
            _mainCard(context, "Analyze Cry", Icons.health_and_safety, const Color(0xFF6366F1), const AnalyzerScreen(), subtitle: "10-point AI check"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _mainCard(context, "Growth", Icons.trending_up, Colors.teal, const GrowthScreen())),
                const SizedBox(width: 16),
                Expanded(child: _mainCard(context, "Photos", Icons.photo, Colors.orange, const GalleryScreen())),
              ],
            ),
            const SizedBox(height: 16),
            _mainCard(context, "Reminders", Icons.notifications_active, Colors.pinkAccent, null, subtitle: "Next feed in 2h 15m"),
          ],
        ),
      ),
    );
  }

  Widget _mainCard(BuildContext ctx, String title, IconData icon, Color color, Widget? route, {String? subtitle}) {
    return GestureDetector(
      onTap: route != null ? () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => route)) : () {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text("Notification features coming soon!")));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(icon, size: 32, color: color)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle, style: const TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}
