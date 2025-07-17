import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/api_network.dart';
List<String> extractIngredients(Map<String, dynamic> data) {
  final ingredients = <String>[];
  final seen = <String>{};
  for (var i = 1; i <= 20; i++) {
    final ingredient = data['strIngredient$i'];
    final measure = data['strMeasure$i'];
    if (ingredient != null &&
        ingredient.toString().trim().isNotEmpty &&
        ingredient.toString().toLowerCase() != 'null') {
      final cleanedIngredient = ingredient.toString().trim();
      final cleanedMeasure = (measure ?? '').toString().trim();
      final combined = cleanedMeasure.isNotEmpty
          ? '$cleanedMeasure $cleanedIngredient'
          : cleanedIngredient;

      if (!seen.contains(combined.toLowerCase())) {
        ingredients.add(combined);
        seen.add(combined.toLowerCase());
      }
    }
  }
  return ingredients;
}
Future<Recipe?> fetchFinalRandomRecipe(BuildContext context) async {
  try {
    final data = await fetchRandomRecipe();
    return Recipe(
      id: data['idMeal'] ?? '',
      name: data['strMeal'] ?? '',
      imageUrl: data['strMealThumb'] ?? '',
      ingredients: extractIngredients(data),
      instructions: data['strInstructions'] ?? '',
      category: data['strCategory'] ?? '',
      area: data['strArea'] ?? '',
      tags: data['strTags'] ?? '',
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch recipe: $e')),
    );
    return null;
  }
}