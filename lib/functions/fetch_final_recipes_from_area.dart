import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/api_network.dart';
import 'fetch_final_recipe_from_id.dart';
Future<List<Recipe>> fetchFinalRecipesFromArea(String area) async {
  final recipeData = await fetchRecipeByArea(area);
  final rawRecipes = recipeData['meals'];
  if (rawRecipes == null) return [];
  final Iterable<Future<Recipe?>> futures = (rawRecipes as List<dynamic>).take(10).map<Future<Recipe?>>((meal) {
    final id = meal['idMeal'];
    return fetchFinalRecipeFromId(id);
  });
  final results = await Future.wait(futures);
  return results.whereType<Recipe>().toList();
}
