import '../models/recipe.dart';
import '../services/network.dart';
Future<Recipe?> fetchRecipeById(String id) async {
  final response = await searchRecipeById(id);
  final meals = response['meals'];
  if (meals != null && meals.isNotEmpty) {
    final mealJson = meals[0];
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = mealJson['strIngredient$i'];
      final measure = mealJson['strMeasure$i'];
      if (ingredient != null &&
          ingredient.trim().isNotEmpty &&
          ingredient.trim().toLowerCase() != 'null') {
        final cleanedIngredient = ingredient.trim();
        final cleanedMeasure = (measure ?? '').trim();
        if (cleanedMeasure.isNotEmpty) {
          ingredients.add('$cleanedMeasure $cleanedIngredient');
        } else {
          ingredients.add(cleanedIngredient);
        }
      }
    }
    return Recipe(
      id: mealJson['idMeal'] ?? '',
      name: mealJson['strMeal'] ?? '',
      category: mealJson['strCategory'] ?? '',
      area: mealJson['strArea'] ?? '',
      imageUrl: mealJson['strMealThumb'] ?? '',
      tags: mealJson['strTags'] ?? '',
      instructions: mealJson['strInstructions'] ?? '',
      ingredients: ingredients,
    );
  }
  return null;
}