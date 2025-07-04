import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseAuthService {
  static final _client = Supabase.instance.client;
  static Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw 'Email and password cannot be empty.';
    }
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        print('Signed up successfully!');
      } else {
        throw response.toString();
      }
    } catch (e) {
      throw 'Sign up failed: $e';
    }
  }
  static Future<void> signIn(String email, String password) async {
    await Supabase.instance.client.auth.refreshSession();
    if (email.isEmpty || password.isEmpty) {
      throw 'Email and password cannot be empty.';
    }
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        print('Signed in! User ID: ${response.user!.id}');
      } else {
        throw 'Invalid credentials.';
      }
    } catch (e) {
      throw 'Sign in failed: $e';
    }
  }
  static Future<void> signOut() async {
    await _client.auth.signOut();
    await Supabase.instance.client.auth.refreshSession();
  }
}