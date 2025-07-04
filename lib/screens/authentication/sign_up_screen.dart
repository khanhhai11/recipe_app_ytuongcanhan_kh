import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
import 'package:recipe_app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showConfirmationStep = false;
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseAuthService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      _showSnackBar('Account created! Please confirm your email before continuing.');
      await Supabase.instance.client.auth.signOut();
      setState(() => _showConfirmationStep = true);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _handleContinueAfterConfirmation() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = response.user;
      if (user != null && user.emailConfirmedAt != null) {
        context.goNamed(Screen.survey.name);
      } else {
        _showSnackBar('Email not confirmed yet. Please confirm via your inbox.');
        await Supabase.instance.client.auth.signOut();
      }
    } catch (e) {
      _showSnackBar('Error signing in. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      appBar: AppBar(
        backgroundColor: const Color(0xffeff1f7),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _showConfirmationStep
            ? Center(
              child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
              const SizedBox(height: 60),
              const Icon(Icons.email_outlined, size: 100, color: Colors.black54),
              const SizedBox(height: 20),
              const Text(
                'Confirm your email',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We\'ve sent a confirmation link to your email.\nClick it, then press below to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xffff475d))
              else
                ElevatedButton(
                  onPressed: _handleContinueAfterConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff475d),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'I confirmed my email',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                        ],
                      ),
            )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter email here',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const Text('Password:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter password here',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xffff475d)))
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff475d),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Or sign up with',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.g_mobiledata, 'Google', () {}),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.facebook, 'Facebook', () {}),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?", style: TextStyle(color: Colors.black87)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.goNamed(Screen.sign_in.name),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffff475d),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildSocialIcon(IconData iconData, String label, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(iconData, size: 28, color: Colors.black87),
        tooltip: label,
      ),
    );
  }
}
// TODO: Add a resend verification button