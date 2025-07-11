import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../router.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isSendingEmail = false;
  bool _isCheckingVerification = false;
  bool _isUpdatingPassword = false;
  bool _isRecovery = false;
  bool? response = null;
  @override
  void initState() {
    super.initState();
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
    print(message);
  }
  Future<void> _handleSendResetEmail() async {
    setState(() => _isSendingEmail = true);
    try {
      final email = _emailController.text.trim();
      response = await SupabaseAuthService.sendResetLink(email);
      _showSnackBar('Reset link sent! Check your email.');
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isSendingEmail = false);
    }
  }
  Future<void> _handleEmailVerifiedCheck() async {
    setState(() => _isCheckingVerification = true);
    try {
      if (response == true) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null && user.emailConfirmedAt != null) {
          _showSnackBar('Email verified! You can now reset your password.');
          setState(() => _isRecovery = true);
        } else {
          _showSnackBar('Email not verified yet. Please check again.');
        }
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('AuthSessionMissingException') ||
          errorMessage.contains('Auth session missing!') ||
          errorMessage.contains('statusCode: 400')) {
        _showSnackBar(
          'Session missing. Please return to the app **using the link in your email** to continue password reset.',
        );
      } else {
        _showSnackBar('Error checking verification: $errorMessage');
      }
    } finally {
      setState(() => _isCheckingVerification = false);
    }
  }
  Future<void> _handlePasswordUpdate() async {
    setState(() => _isUpdatingPassword = true);
    try {
      final newPassword = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      await SupabaseAuthService.updatePassword(newPassword, confirmPassword);
      _showSnackBar('Password updated! You can now sign in.');
      context.goNamed(Screen.sign_in.name);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isUpdatingPassword = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isRecovery ? 'Reset Password' : 'Forgot Password',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _isRecovery ? _buildResetForm() : _buildEmailForm(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your email to receive a password reset link.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: _inputStyle('Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSendingEmail ? null : _handleSendResetEmail,
          style: _buttonStyle(),
          child: _isSendingEmail
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Send Reset Link', style: TextStyle(color: Colors.white)),
        ),
        const Divider(height: 40),
        Center(
          child: Column(
            children: const [
              Text(
                'Already clicked the link?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Return to this app to reset your password.',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isCheckingVerification ? null : _handleEmailVerifiedCheck,
          style: _buttonStyle(),
          child: _isCheckingVerification
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("I've verified my email", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email verified. You can now reset your password.',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Enter your new password.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: _inputStyle('New Password'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: _inputStyle('Confirm New Password'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isUpdatingPassword ? null : _handlePasswordUpdate,
          style: _buttonStyle(),
          child: _isUpdatingPassword
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xffff475d),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
// TODO: I think that this only work on Iphone so yea