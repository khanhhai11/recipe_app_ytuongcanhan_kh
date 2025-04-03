import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_extractor/recipe_extractor.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/recipe.dart';
import '../recipe_extractor/recipe_extractor_models/recipe_data.dart';
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}
class _RecipeScreenState extends State<RecipeScreen> {
  RecipeData? extractedRecipe;
  String servings = '';
  String prepTime = '';
  String cookTime = '';
  String calories = '';
  String fat = '';
  String carbs = '';
  String protein = '';
  @override
  void initState(){
    super.initState();
    _extractRecipe(widget.recipe.recipeUrl);
  }
  Future<void> _extractRecipe(String recipeUrl) async {
    try {
      RecipeData recipeData = await extractRecipe(recipeUrl);
      setState(() {
        extractedRecipe = recipeData;
        servings = '${extractedRecipe?.servings}';
        prepTime = '${extractedRecipe?.prepTime}';
        cookTime = '${extractedRecipe?.cookTime}';
        calories = '${extractedRecipe?.calories}';
        fat = '${extractedRecipe?.fat}';
        carbs = '${extractedRecipe?.carbs}';
        protein = '${extractedRecipe?.protein}';
      });
    } catch (e) {
      print('Error extracting recipe: $e');
    }
  }
  String totalTime() {
    int prepTime = int.tryParse(RegExp(r'\d+').stringMatch(extractedRecipe?.prepTime ?? '0') ?? '0') ?? 0;
    int cookTime = int.tryParse(RegExp(r'\d+').stringMatch(extractedRecipe?.cookTime ?? '0') ?? '0') ?? 0;
    return '${prepTime + cookTime} mins';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.recipe.imageUrl,
                  fit: BoxFit.cover,
                  height: 170,
                  width: double.infinity,
                ),
              ),
              Text('Servings: $servings'),
              Text('Prepare time: $prepTime'),
              Text('Cook time: $cookTime'),
              Text('Total time: $totalTime'),
              Text('Calories: $calories'),
              Text('Fat: $fat'),
              Text('Carbs: $carbs'),
              Text('Protein: $protein'),
            ],
          ),
        ),
      ),
    );
  }
}
// TODO: Fix String totalTime
// TODO: Fix it so that there won't be the 'Recipe is not a subtype of type String'
// TODO: Edit the UI to make it look better
// TODO: Add animation for everything
// TODO: In the steps screen, add shared axis animation (A stepper transitions along the y-axis, https://pub.dev/packages/animations)
// TODO: When code favourite, use Provider, stop callback function
// TODO: Make the nutrtion facts in a container with the color of the theme, 2 statistics per row with a subtitle