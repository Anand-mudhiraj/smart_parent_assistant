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
