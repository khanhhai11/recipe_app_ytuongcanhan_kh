enum Complexity { simple, normal, challenging }
class Recipe {
  const Recipe({
    required this.name,
    required this.categories,
    required this.imageUrl,
    required this.recipeUrl,
    required this.duration,
    required this.isDairyFree,
    required this.isVegan,
    required this.complexity,
  });
  final String name;
  final List<String> categories;
  final String imageUrl;
  final String recipeUrl;
  final String duration;
  final bool isDairyFree;
  final bool isVegan;
  final Complexity complexity;
}