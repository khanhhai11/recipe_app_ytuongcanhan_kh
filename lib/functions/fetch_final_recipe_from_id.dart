import '../models/recipe.dart';
import '../services/api_network.dart';
Future<Recipe?> fetchFinalRecipeFromId(String id) async {
  final response = await searchRecipeById(id);
  final meals = response['meals'];
  if (meals != null && meals.isNotEmpty) {
    final mealJson = meals[0];
    List<String> ingredients = [];
    final seenIngredients = <String>{};
    for (int i = 1; i <= 20; i++) {
      final ingredient = mealJson['strIngredient$i'];
      final measure = mealJson['strMeasure$i'];
      if (ingredient != null &&
          ingredient.trim().isNotEmpty &&
          ingredient.trim().toLowerCase() != 'null') {
        final cleanedIngredient = ingredient.trim();
        final cleanedMeasure = (measure ?? '').trim();
        final combined = cleanedMeasure.isNotEmpty
            ? '$cleanedMeasure $cleanedIngredient'
            : cleanedIngredient;
        if (!seenIngredients.contains(combined.toLowerCase())) {
          ingredients.add(combined);
          seenIngredients.add(combined.toLowerCase());
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