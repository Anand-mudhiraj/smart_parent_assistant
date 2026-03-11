import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features.dart';
import 'services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vqhyssgbickiexkxgcqn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxaHlzc2diaWNraWV4a3hnY3FuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNDc0MTAsImV4cCI6MjA4ODgyMzQxMH0.BP4_h6FozzGFZ1gCmgNyCVutlneK3hvzMdTP-4f1yaI',
  );
  runApp(const ProductionApp());
}

class ProductionApp extends StatelessWidget {
  const ProductionApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(useMaterial3: true, fontFamily: 'Segoe UI', colorSchemeSeed: const Color(0xFF2563EB)), home: const AuthWrapper());
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}
class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() { super.initState(); Supabase.instance.client.auth.onAuthStateChange.listen((_) { if(mounted) setState((){}); }); }
  @override
  Widget build(BuildContext context) => AppServices.currentUser == null ? const AuthScreen() : const Dashboard();
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController(), _pass = TextEditingController();
  bool _isLogin = true, _loading = false;

  void _submit() async {
    setState(() => _loading = true);
    try {
      if (_isLogin) await AppServices.signIn(_email.text.trim(), _pass.text);
      else await AppServices.signUp(_email.text.trim(), _pass.text);
    } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent)); }
    if(mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(30)), child: const Icon(Icons.favorite, size: 60, color: Color(0xFF2563EB))),
              const SizedBox(height: 32),
              Text(_isLogin ? "Welcome Back" : "Create Account", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
              const SizedBox(height: 40),
              TextField(controller: _email, decoration: InputDecoration(labelText: "Email", filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              TextField(controller: _pass, obscureText: true, decoration: InputDecoration(labelText: "Password", filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
              const SizedBox(height: 32),
              _loading ? const CircularProgressIndicator() : SizedBox(width: double.infinity, height: 56, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _submit, child: Text(_isLogin ? "Login" : "Sign Up", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 16),
              TextButton(onPressed: () => setState(() => _isLogin = !_isLogin), child: Text(_isLogin ? "Don't have an account? Sign up" : "Already have an account? Log in", style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)))
            ],
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  Timer? _ticker;
  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) => setState((){}));
  }
  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }

  String _getTimeLeft() {
    if (TimerManager.targetTime == null) return "Set Reminder";
    final diff = TimerManager.targetTime!.difference(DateTime.now());
    if (diff.isNegative) return "Feed Due!";
    return "Due in ${diff.inHours}h ${diff.inMinutes.remainder(60)}m ${diff.inSeconds.remainder(60)}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                IconButton(icon: const Icon(Icons.logout, color: Colors.grey), onPressed: () => AppServices.signOut())
              ]),
              const SizedBox(height: 32),
              
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimerScreen())),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.timer, color: Colors.white, size: 28)),
                      const SizedBox(width: 20),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("Next Feed", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(_getTimeLeft(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()])),
                      ])
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              const Text("Assessments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              _card(context, "Symptom Checker", "AI-powered diagnostics", Icons.health_and_safety, const Color(0xFF2563EB), const AnalyzerScreen()),
              
              const SizedBox(height: 32),
              const Text("Records", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _sqCard(context, "Growth", Icons.trending_up, const Color(0xFF10B981), const GrowthScreen())),
                  const SizedBox(width: 16),
                  Expanded(child: _sqCard(context, "Photos", Icons.photo_library, const Color(0xFFF59E0B), const GalleryScreen())),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext ctx, String t, String s, IconData i, Color c, Widget r) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => r)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(i, color: c, size: 28)),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))), const SizedBox(height: 4), Text(s, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))])),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1))
          ],
        ),
      ),
    );
  }

  Widget _sqCard(BuildContext ctx, String t, IconData i, Color c, Widget r) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => r)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Icon(i, color: c, size: 28)),
            const SizedBox(height: 20),
            Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}
