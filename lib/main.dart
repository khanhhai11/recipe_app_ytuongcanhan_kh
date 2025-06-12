import 'package:flutter/material.dart';
import 'package:recipe_app/router.dart';
void main() {
  runApp(
    const RecipeApp(),
  );
}
class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});
  @override
  State<RecipeApp> createState() => _RecipeAppState();
}
class _RecipeAppState extends State<RecipeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffeff1f7),
        primaryColor: const Color(0xFFff475D),
        useMaterial3: true,
      ),
    );
  }
}
// TODO: Load category and area 1 time and save it to cache
// TODO: Handle favourite system using shared preference (setString)
// TODO: Handle Snackbar + comment and star rating submission
// TODO: Research supabase_flutter to handle star & comments
// TODO: Make survey_screen UI less blank