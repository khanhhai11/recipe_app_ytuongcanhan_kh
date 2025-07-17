import '../models/recipe.dart';
import '../services/api_network.dart';

Future<List<Recipe>> searchFinalRecipesFromName(String name) async {
  final recipeData = await searchRecipeByName(name);
  final rawRecipes = recipeData['meals'];
  if (rawRecipes == null) return [];

  return rawRecipes.map<Recipe>((recipeMap) {
    final ingredients = <String>[];
    final seen = <String>{};

    for (var i = 1; i <= 20; i++) {
      final ingredient = recipeMap['strIngredient$i'];
      final measure = recipeMap['strMeasure$i'];

      if (ingredient != null &&
          ingredient.trim().isNotEmpty &&
          ingredient.trim().toLowerCase() != 'null') {
        final cleanedIngredient = ingredient.trim();
        final cleanedMeasure = (measure ?? '').trim();
        final combined = cleanedMeasure.isNotEmpty
            ? '$cleanedMeasure $cleanedIngredient'
            : cleanedIngredient;

        if (!seen.contains(combined.toLowerCase())) {
          ingredients.add(combined);
          seen.add(combined.toLowerCase());
        }
      }
    }

    return Recipe(
      id: recipeMap['idMeal'] ?? '',
      name: recipeMap['strMeal'] ?? '',
      category: recipeMap['strCategory'] ?? '',
      area: recipeMap['strArea'] ?? '',
      imageUrl: recipeMap['strMealThumb'] ?? '',
      tags: recipeMap['strTags'] ?? '',
      instructions: recipeMap['strInstructions'] ?? '',
      ingredients: ingredients,
    );
  }).toList();
}
