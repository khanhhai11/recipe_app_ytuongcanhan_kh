import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseAuthService {
  static final _client = Supabase.instance.client;
  static User? get currentUser => _client.auth.currentUser;
  static Future<void> signUp(String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      throw 'All fields are required.';
    }
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': username,
        },
      );
      print('OTP sent to $email. Awaiting user confirmation.');
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('user already registered')) {
        throw 'This email is already in use. Try signing in instead.';
      }
      throw 'Sign up failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }
  static Future<void> verifySignupOTP(String email, String token) async {
    final result = await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
    if (result.user == null) {
      throw 'Invalid or expired OTP.';
    }
  }
  static Future<void> resendSignupOTP(String username, String email, String password) async {
    await signUp(username, email, password);
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
  static Future<void> sendResetOTP(String email) async {
    if (email.isEmpty) throw 'Please enter your email.';
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback',
      );
      print('Reset OTP sent!');
    } catch (e) {
      print('Failed to send reset OTP: $e');
      throw 'Failed to send reset OTP: $e';
    }
  }
  static Future<void> updatePasswordWithToken({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty || token.isEmpty) {
      throw 'All fields are required.';
    }
    if (newPassword != confirmPassword) {
      throw 'Passwords do not match.';
    }
    try {
      final result = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
      if (result.user == null) {
        throw 'Invalid token or expired link.';
      }
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw 'Password update failed: ${e.message}';
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }
}