class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.tags,
    required this.ingredients,
    required this.instructions,
  });
  final String id;
  final String name;
  final String category;
  final String area;
  final String imageUrl;
  final String tags;
  final List<String> ingredients;
  final String instructions;
}