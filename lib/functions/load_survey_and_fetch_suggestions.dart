import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/survey_answer.dart';
import 'package:recipe_app/services/supabase_survey.dart';
import 'fetch_final_recipes_from_area.dart';
import 'fetch_final_recipes_from_category.dart';
Future<(SurveyAnswer?, List<Recipe>)> loadSurveyAndFetchSuggestions(BuildContext context) async {
  try {
    final answer = await SupabaseSurveyService.fetchCurrentUserAnswer();
    List<Recipe> suggestions = [];
    final isVegan = answer?.isVegan ?? false;
    final area = answer?.area ?? '';
    if (isVegan) {
      final recipes = await fetchFinalRecipesFromCategory('Vegan');
      suggestions = area.isEmpty
          ? recipes.take(5).toList()
          : recipes.where((r) => r.area.toLowerCase() == area.toLowerCase()).take(5).toList();
    } else if (area.isNotEmpty) {
      suggestions = await fetchFinalRecipesFromArea(area);
    }
    return (answer, suggestions);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading survey or recipes: $e')),
    );
    return (null, <Recipe>[]);
  }
}