import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseAuthService {
  static final _client = Supabase.instance.client;
  static Future<void> signUp(String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      throw 'All fields are required.';
    }
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': username,
        },
      );
      if (response.user != null) {
        print('Signed up successfully!');
      } else {
        throw response.toString();
      }
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('user already registered')) {
        throw 'This email is already in use. Try signing in instead.';
      }
      throw 'Sign up failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }
  static Future<void> signInWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://localhost:3000',
      );
    } catch (e) {
      throw 'Google sign-in failed: $e';
    }
  }
  static Future<void> signIn(String email, String password) async {
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
  static Future<bool> sendResetLink(String email) async {
    if (email.isEmpty) throw 'Please enter your email.';
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback',
      );
      print('Reset email sent!');
      return true;
    } catch (e) {
      print('Failed to send reset email: $e');
      throw 'Failed to send reset email: $e';
    }
  }
  static Future<void> updatePassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      throw 'Please fill in both fields.';
    }
    if (newPassword != confirmPassword) {
      throw 'Passwords do not match.';
    }
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw 'Failed to update password: $e';
    }
  }
}