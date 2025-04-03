import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/recipebox_logo.png', height: 100),
            Text(
              'RecipeBox',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.goNamed('home');
                // TODO: Delete the turn back button in HomeScreen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(225, 60),
                elevation: 5,
              ),
              child: Text(
                'Start Cooking',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}