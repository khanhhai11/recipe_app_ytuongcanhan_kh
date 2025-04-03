class RecipeData {
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  String? servings;
  String? image;
  String? source;
  String? prepTime;
  String? cookTime;
  String? calories;
  String? fat;
  String? carbs;
  String? protein;
  RecipeData({
    this.name,
    this.image,
    this.servings,
    this.ingredients,
    this.instructions,
    this.source,
    this.prepTime,
    this.cookTime,
    this.calories,
    this.fat,
    this.carbs,
    this.protein,
  });
}