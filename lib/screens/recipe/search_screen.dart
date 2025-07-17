import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:recipe_app/widgets/search_recipe_bar.dart';
import '../../functions/fetch_final_recipes_from_area.dart';
import '../../functions/search_final_recipes_from_name.dart';
import '../../models/recipe.dart';
import '../../widgets/recipe_item.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.searchText,
    required this.isFromArea,
  });
  final String searchText;
  final bool isFromArea;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> detailedRecipes = [];
  bool _isLoading = true;
  bool _notFound = false;
  @override
  void initState() {
    super.initState();
    _runSearch(widget.searchText);
  }
  Future<void> _runSearch(String text) async {
    setState(() {
      _isLoading = true;
      _notFound = false;
    });
    List<Recipe> results = [];
    if (widget.isFromArea) {
      results = await fetchFinalRecipesFromArea(text);
    } else {
      results = await searchFinalRecipesFromName(text);
    }
    setState(() {
      detailedRecipes = results;
      _isLoading = false;
      _notFound = results.isEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffeff1f7),
        appBar: AppBar(
          backgroundColor: const Color(0xffeff1f7),
          title: widget.isFromArea
              ? Text(
            widget.searchText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          )
              : Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 16),
            child: SearchRecipeBar(
              onSearch: (text) async {
                setState(() => detailedRecipes = []);
                _runSearch(text);
              },
              initialText: widget.searchText,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin,
                  colors: [Color(0xFFFF475D)],
                  strokeWidth: 5.0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Please wait, loading recipes...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFff475D),
                ),
              ),
            ],
          ),
        )
            : _notFound
            ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '😕 Oops, nothing found!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFff475D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                  indent: 50,
                  endIndent: 50,
                ),
                const SizedBox(height: 12),
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
        )
            : ListView.builder(
          itemCount: detailedRecipes.length,
          itemBuilder: (context, index) {
            final recipe = detailedRecipes[index];
            return RecipeItem(recipe: recipe);
          },
        ),
      ),
    );
  }
}