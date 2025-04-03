import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/search_recipe_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeff1f7),
      appBar: AppBar(
        backgroundColor: Color(0xffeff1f7),
        title: Text('Hungry?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a recipe for yourself in RecipeBox and do it!\nLots of quality recipes are waiting for you!',
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  child: SearchRecipeBar(onSearch: (text) async {
                    context.goNamed(Screen.search.name, extra: text.toString());
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}