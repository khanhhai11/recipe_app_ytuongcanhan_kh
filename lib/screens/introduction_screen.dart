import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router.dart';
class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/recipebox_introphoto.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Positioned(
            top: -18,
            right: -10,
            child: Image.asset(
              color: Color(0xFFEDCED2),
              'assets/images/recipebox_leafycorner.png',
              width: 180,
            ),
          ),
          Positioned(
            bottom: -18,
            left: -10,
            child: Transform.rotate(
              angle: 3.1416,
              child: Image.asset(
                color: Color(0xFFEDCED2),
                'assets/images/recipebox_leafycorner.png',
                width: 180,
              ),
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            top: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/recipebox_logo.png',
                  width: 135,
                  height: 135,
                ),
                const SizedBox(height: 8),
                const Text(
                  'RecipeBox',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Unlock your inner chef - one recipe at a time!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => context.goNamed(Screen.survey.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Start cooking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              'Created by Flutter\nDatabase from TheMealDB.com',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}