import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/widgets/search_recipe_bar.dart';
import '../models/recipe.dart';
import 'package:recipe_app/data/recipes.dart';
import '../widgets/recipe_item.dart';
import 'package:recipe_app/router.dart';
class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required this.searchText});
  final String searchText;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> _filteredRecipes = [];
  @override
  void initState() {
    super.initState();
    _search(widget.searchText);
  }
  void _search(String text) {
    setState(() {
      _filteredRecipes = recipeData
          .where((recipe) => removeDiacritics(recipe.name.toLowerCase())
          .contains(removeDiacritics(text.toLowerCase()))).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeff1f7),
      appBar: AppBar(
        backgroundColor: Color(0xffeff1f7),
        title: SearchRecipeBar(
          onSearch: (text) async { _search(text); },
          initialText: widget.searchText,
        ),
      ),
      body: _filteredRecipes.isNotEmpty
          ? ListView.builder(
            itemCount: _filteredRecipes.length,
            itemBuilder: (context, index) => RecipeItem(recipe: _filteredRecipes[index]),
          )
          : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '😕 Oops, nothing found!',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFff475D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Divider(thickness: 1, color: Colors.black, indent: 50, endIndent: 50),
                    SizedBox(height: 12),
                    Text(
                      'Try searching for something else.\nMaybe check your spelling?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
              ),
            ),
          ),
    );
  }
}