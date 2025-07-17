import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/api_network.dart';
import 'fetch_final_recipe_from_id.dart';
Future<List<Recipe>> fetchFinalRecipesFromCategory(String categoryName) async {
  final data = await fetchRecipeByCategory(categoryName);
  final meals = data['meals'] ?? [];
  final Iterable<Future<Recipe?>> futures = (meals as List<dynamic>).take(10).map((meal) {
    final id = meal['idMeal'];
    return fetchFinalRecipeFromId(id);
  });
  final results = await Future.wait(futures);
  return results.whereType<Recipe>().toList();
}
