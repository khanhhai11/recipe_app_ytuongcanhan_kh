import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
import '../../router.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isSendingEmail = false;
  bool _isUpdatingPassword = false;
  bool _showResetForm = false;
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
  Future<void> _handleSendResetOTP() async {
    setState(() => _isSendingEmail = true);
    try {
      final email = _emailController.text.trim();
      await SupabaseAuthService.sendResetOTP(email);
      _showSnackBar('Reset token sent! Check your email.');
      setState(() => _showResetForm = true);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isSendingEmail = false);
    }
  }
  Future<void> _handlePasswordUpdate() async {
    setState(() => _isUpdatingPassword = true);
    try {
      final token = _tokenController.text.trim();
      final email = _emailController.text.trim();
      final newPassword = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      await SupabaseAuthService.updatePasswordWithToken(
        email: email,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _showSnackBar('Password updated! You can now sign in.');
      context.goNamed(Screen.sign_in.name);
    } catch (e) {
      if (e.toString().contains('Token has expired')) {
        _showSnackBar('Token expired. Please request a new one.');
        setState(() => _showResetForm = false);
      } else {
        _showSnackBar(e.toString());
      }
    } finally {
      setState(() => _isUpdatingPassword = false);
    }
  }
  Future<void> _resendToken() async {
    setState(() => _isSendingEmail = true);
    try {
      final email = _emailController.text.trim();
      await SupabaseAuthService.sendResetOTP(email);
      _showSnackBar('A new reset token has been sent to your email.');
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isSendingEmail = false);
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
                  const Text(
                    'Create new password',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _showResetForm ? _buildResetForm() : _buildEmailForm(),
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
          'Enter the email associated with your account:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        _styledField(controller: _emailController, hint: 'Email', icon: Icons.email),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSendingEmail ? null : _handleSendResetOTP,
          style: _buttonStyle(),
          child: _isSendingEmail
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Send Reset Token', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 24),
        _infoBox(),
      ],
    );
  }
  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the reset token from your email and set a new password.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        _styledField(controller: _tokenController, hint: 'Reset Token', icon: Icons.vpn_key),
        const SizedBox(height: 16),
        _styledField(controller: _emailController, hint: 'Email', icon: Icons.email, readOnly: true),
        const SizedBox(height: 16),
        _styledField(controller: _newPasswordController, hint: 'New Password', icon: Icons.lock, obscure: true),
        const SizedBox(height: 16),
        _styledField(controller: _confirmPasswordController, hint: 'Confirm Password', icon: Icons.lock, obscure: true),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isUpdatingPassword? null: _handlePasswordUpdate,
          style: _buttonStyle(),
          child: _isUpdatingPassword
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Reset Password', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Didn’t get the email?",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _isSendingEmail ? null : _resendToken,
              child: Text(
                'Resend token',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isSendingEmail ? Colors.grey : const Color(0xffff475d),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  Widget _styledField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffffd5db),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffffa1af)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xffff475d), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'What happens next?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffff475d),
                  ),
                ),
                SizedBox(height: 8),
                Text('1. We’ll send a reset token to your email'),
                Text('2. Check your inbox (and spam folder)'),
                Text('3. Copy the token and use it on the next screen'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xffff475d),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}