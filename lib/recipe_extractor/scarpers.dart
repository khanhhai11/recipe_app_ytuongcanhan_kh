import 'package:recipe_app/recipe_extractor/scarpers/allrecipes.dart';
import 'package:recipe_app/recipe_extractor/scarpers/bbcgoodfood.dart';
import 'package:recipe_app/recipe_extractor/scarpers/simplyrecipes.dart';
import 'package:recipe_app/recipe_extractor/recipe_extractor_models/scarper.dart';
List<Scarper> scarpers = [
  Allrecipes(),
  Bbcgoodfood(),
  Simplyrecipes(),
];