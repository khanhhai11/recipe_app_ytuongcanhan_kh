import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
import '../../router.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _showTokenInput = false;
  int _resendCooldown = 0;
  Timer? _resendTimer;
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseAuthService.signUp(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      _showSnackBar('OTP sent to your email.');
      setState(() => _showTokenInput = true);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseAuthService.verifySignupOTP(
        _emailController.text.trim(),
        _tokenController.text.trim(),
      );
      _showSnackBar('Verification successful!');
      context.goNamed(Screen.survey.name);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _resendOTP() async {
    if (_resendCooldown > 0) return;
    setState(() {
      _isLoading = true;
      _resendCooldown = 60;
    });
    try {
      await SupabaseAuthService.resendSignupOTP(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      _showSnackBar('OTP resent to your email.');
      _resendTimer?.cancel();
      _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendCooldown == 0) {
          timer.cancel();
        } else {
          setState(() => _resendCooldown--);
        }
      });
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      appBar: AppBar(
        backgroundColor: const Color(0xffeff1f7),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffdcdfe5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 420),
              child: IntrinsicHeight(
                child: _showTokenInput ? _buildOTPInputForm() : _buildSignUpForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildInputField('Username:', _usernameController, Icons.person_outline, 'Enter username here'),
        const SizedBox(height: 24),
        _buildInputField('Email:', _emailController, Icons.email_outlined, 'Enter email here', TextInputType.emailAddress),
        const SizedBox(height: 24),
        _buildInputField('Password:', _passwordController, Icons.lock_outline, 'Enter password here', TextInputType.text, true),
        const SizedBox(height: 36),
        _buildSubmitButton(_handleSignUp, 'Continue'),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?", style: TextStyle(color: Colors.black87)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => context.goNamed(Screen.sign_in.name),
              child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffff475d))),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  Widget _buildOTPInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        const Center(child: Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.black54)),
        const SizedBox(height: 20),
        const Center(
          child: Text('Enter OTP from your email to verify',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tokenController,
          decoration: InputDecoration(
            hintText: 'Enter the 6-digit code',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 30),
        _buildSubmitButton(_verifyOTP, 'Verify OTP'),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _resendCooldown == 0 ? _resendOTP : null,
            child: Text(
              _resendCooldown == 0 ? 'Resend OTP' : 'Resend in $_resendCooldown s',
              style: TextStyle(
                color: _resendCooldown == 0 ? const Color(0xffff475d) : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildInputField(
      String label,
      TextEditingController controller,
      IconData icon,
      String hintText, [
        TextInputType inputType = TextInputType.text,
        bool obscureText = false,
      ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: inputType,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }
  Widget _buildSubmitButton(VoidCallback onPressed, String text) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xffff475d)))
        : SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffff475d),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}