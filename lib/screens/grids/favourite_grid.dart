import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/widgets/squared_recipe_item.dart';
import '../../functions/fetch_final_recipe_from_id.dart';
import '../../models/recipe.dart';
import '../../providers/favourite_provider.dart';
class FavouriteGrid extends StatelessWidget {
  const FavouriteGrid({super.key});
  Future<List<Recipe>> _loadFavouriteRecipes(Set<String> ids) async {
    final recipes = <Recipe>[];
    for (final id in ids) {
      final recipe = await fetchFinalRecipeFromId(id);
      if (recipe != null) {
        recipes.add(recipe);
      }
    }
    return recipes;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFEFF1F7),
        title: const Text(
          'Your Favourites',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Consumer<FavouritesProvider>(
        builder: (context, favouritesProvider, _) {
          final favouriteIds = favouritesProvider.favourites;
          return FutureBuilder<List<Recipe>>(
            future: _loadFavouriteRecipes(favouriteIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final recipes = snapshot.data ?? [];
              if (recipes.isEmpty) {
                return const Center(child: Text('No favourites yet'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: recipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => SquaredRecipeItem(recipe: recipes[index]),
              );
            },
          );
        },
      ),
    );
  }
}