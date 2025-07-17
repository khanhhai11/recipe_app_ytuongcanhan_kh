import 'package:flutter/material.dart';
import 'package:recipe_app/functions/fetch_final_recipes_from_category.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../widgets/recipe_item.dart';
class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key, required this.category});
  final Category category;
  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}
class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }
  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);
    try {
      final recipes = await fetchFinalRecipesFromCategory(widget.category.name);
      if (mounted) {
        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load recipes: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      appBar: AppBar(
        backgroundColor: const Color(0xffeff1f7),
        title: Text(
          widget.category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF475D)))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.category.thumbnail,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
                fadeInDuration: const Duration(milliseconds: 500),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.category.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recipes:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._recipes.map((recipe) => RecipeItem(recipe: recipe)).toList(),
          ],
        ),
      ),
    );
  }
}