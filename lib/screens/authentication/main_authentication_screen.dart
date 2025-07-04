import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
class MainAuthenticationScreen extends StatelessWidget {
  const MainAuthenticationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: const BoxDecoration(
                color: Color(0xffff475d),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.restaurant_menu, size: 60, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to\nRecipeBox',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'assets/images/recipebox_decoratedish.png',
                        height: 600,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      flex: 5,
                      child: Text.rich(
                        TextSpan(
                          text: 'Join us and ',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'discover ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: 'delicious recipes\n'),
                            TextSpan(text: 'curated ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'just for you!'),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.goNamed(Screen.sign_up.name),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff475d),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.goNamed(Screen.sign_in.name),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xffff475d)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffff475d),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}