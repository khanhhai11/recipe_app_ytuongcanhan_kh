import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jmesrzriskdmrmvcyabg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImptZXNyenJpc2tkbXJtdmN5YWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3MzU1ODAsImV4cCI6MjA2NTMxMTU4MH0.rxBbEUcr_Et_efXyD-jcUWiWd9-SEWhVEOnEvDisVo8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  if (kIsWeb == false){
    await Supabase.instance.client.auth.getSessionFromUrl(Uri.base);
  }
  runApp(const RecipeApp());
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
// TODO: Make hard category and area files so no need to load anymore
// TODO: Handle favourite system using supabase
// TODO: Handle Snackbar + comment and star rating submission
// TODO: Research supabase_flutter to handle star & comments
// TODO: Make survey_screen UI less blank
// TODO: Add filter by main ingredients
// TODO: Fix categories part so that we don't use again search screen, add a category description (fetchable) with details button
// TODO: Add average star ratings for all recipe & suggestions item
// TODO: Add supabase authentication (sign up, sign in,...) and UI
// TODO: Replace survey shared_preferences into supabase for each userId
// TODO: Check when user signed up, if there is an account with the same name -> tell the user
// TODO: Fix Google Log In