import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../widgets/suggestion_recipe_item.dart';
class AllSuggestionsScreen extends StatelessWidget {
  const AllSuggestionsScreen({super.key, required this.recipes});
  final List<Recipe> recipes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Suggestions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: Color(0xffeff1f7),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3/4,
        ),
        itemBuilder: (context, index) {
          return SuggestionRecipeItem(recipe: recipes[index]);
        },
      ),
    );
  }
}