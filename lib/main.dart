import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/favourite_provider.dart';
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
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavouritesProvider(),
      child: const RecipeBox(),
    ),
  );
}
class RecipeBox extends StatefulWidget {
  const RecipeBox({super.key});
  @override
  State<RecipeBox> createState() => _RecipeBoxState();
}
class _RecipeBoxState extends State<RecipeBox> {
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
// TODO: Make survey_screen UI less blank
// TODO: Add filter by main ingredients
// TODO: Make mail verify UI more professional
// TODO: Code the account info and survey data screen
// TODO: Remove the show snack bar error