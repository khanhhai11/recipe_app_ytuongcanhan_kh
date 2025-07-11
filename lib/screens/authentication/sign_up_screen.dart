import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/services/supabase_authentication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../router.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.showConfirmation = false});
  final bool showConfirmation;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _showConfirmationStep = false;
  @override
  void initState() {
    super.initState();
    _showConfirmationStep = widget.showConfirmation;
  }
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
      _showSnackBar('Account created! Check your email and confirm.');
      setState(() => _showConfirmationStep = true);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _trySignInAfterConfirmation() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = response.user;
      if (user != null && user.emailConfirmedAt != null) {
        _showSnackBar("Email verified. Please complete the survey.");
        if (mounted) {
          context.goNamed(Screen.survey.name);
        }
      } else {
        _showSnackBar("Still not confirmed. Please check your email.");
        await Supabase.instance.client.auth.signOut();
      }
    } catch (e) {
      _showSnackBar("Sign-in failed. ${e.toString()}");
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
            ? _buildConfirmationMessage()
            : _buildSignUpForm(),
      ),
    );
  }
  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text('Username:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Enter username here',
            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Enter email here',
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
        else
          SizedBox(
            width: double.infinity,
            height: 44,
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
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: () async {
              // try {
              //   await SupabaseAuthService.signInWithGoogle();
              // } catch (e) {
              //   _showSnackBar(e.toString());
              // }
            },
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Color(0xFFFF475D),
              size: 20,
            ),
            label: const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xffff475d), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?", style: TextStyle(color: Colors.black87)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
    );
  }
  Widget _buildConfirmationMessage() {
    return Center(
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
            'We\'ve sent a confirmation link to your email.\nClick it, then tap below.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          if (_isLoading)
            const CircularProgressIndicator(color: Color(0xffff475d))
          else
            ElevatedButton(
              onPressed: _trySignInAfterConfirmation,
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
    );
  }
}
// TODO: Finish GoogleSignIn by making a cloud project, get ClientIds and ClientSecret, paste into supabase and it will work (on app ig)