import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:recipe_app/services/network.dart';
import 'package:recipe_app/widgets/search_recipe_bar.dart';
import '../models/recipe.dart';
import '../widgets/recipe_filtered_item.dart';
import '../widgets/recipe_item.dart';
class SearchScreen extends StatefulWidget {
  SearchScreen({
    super.key,
    required this.searchText,
    required this.isFromCategory,
    required this.isFromArea,
    required this.isFromSuggestion,
  });
  final String searchText;
  final bool isFromCategory;
  final bool isFromArea;
  final bool isFromSuggestion;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> detailedRecipes = [];
  List<Recipe> categoryRecipes = [];
  List<Recipe> areaRecipes = [];
  bool _isLoading = true;
  bool _notFound = false;
  @override
  void initState() {
    super.initState();
    if (widget.isFromCategory) {
      _fetchCategoryRecipes(widget.searchText);
    } else if (widget.isFromArea) {
      _fetchAreaRecipes(widget.searchText);
    } else {
      _search(widget.searchText);
    }
  }
  void _search(String text) async {
    if (detailedRecipes.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _notFound = false;
      });
      return null;
    }
    setState(() {
      _isLoading = true;
      _notFound = false;
    });
    final recipeData = await searchRecipeByName(text);
    final rawRecipes = recipeData['meals'];
    if (rawRecipes == null) {
      setState(() {
        _isLoading = false;
        _notFound = true;
        detailedRecipes = [];
      });
      return null;
    }
    final _filteredRecipes = rawRecipes.map<Recipe>((recipeMap) {
      final ingredients = <String>[];
      for (var i = 1; i <= 20; i++) {
        final ingredient = recipeMap['strIngredient$i'];
        final measure = recipeMap['strMeasure$i'];
        if (ingredient != null &&
            ingredient.trim().isNotEmpty &&
            ingredient.trim().toLowerCase() != 'null') {
          final cleanedIngredient = ingredient.trim();
          final cleanedMeasure = (measure ?? '').trim();
          ingredients.add(
            cleanedMeasure.isNotEmpty
                ? '$cleanedMeasure $cleanedIngredient'
                : cleanedIngredient,
          );
        }
      }
      return Recipe(
        id: recipeMap['idMeal'] ?? '',
        name: recipeMap['strMeal'] ?? '',
        category: recipeMap['strCategory'] ?? '',
        area: recipeMap['strArea'] ?? '',
        imageUrl: recipeMap['strMealThumb'] ?? '',
        tags: recipeMap['strTags'] ?? '',
        instructions: recipeMap['strInstructions'] ?? '',
        ingredients: ingredients,
      );
    }).toList();
    setState(() {
      detailedRecipes = _filteredRecipes;
      _isLoading = false;
    });
  }
  Future<void> _fetchCategoryRecipes(String category) async {
    setState(() {
      _isLoading = true;
      _notFound = false;
    });
    try {
      final recipeData = await fetchRecipeByCategory(category);
      final rawRecipes = recipeData['meals'];
      if (rawRecipes == null || rawRecipes.isEmpty) {
        setState(() {
          _isLoading = false;
          _notFound = true;
          categoryRecipes = [];
        });
        return null;
      }
      List<Recipe> _filteredRecipes = rawRecipes.map<Recipe>((recipeMap) {
        return Recipe(
          id: recipeMap['idMeal'] ?? '',
          name: recipeMap['strMeal'] ?? '',
          category: category,
          area: '',
          imageUrl: recipeMap['strMealThumb'] ?? '',
          tags: '',
          instructions: '',
          ingredients: [],
        );
      }).toList();
      setState(() {
        categoryRecipes = _filteredRecipes;
        _isLoading = false;
        _notFound = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _notFound = true;
        categoryRecipes = [];
      });
    }
  }
  Future<void> _fetchAreaRecipes(String area) async {
    setState(() {
      _isLoading = true;
      _notFound = false;
    });
    try {
      final recipeData = await fetchRecipeByArea(area);
      final rawRecipes = recipeData['meals'];
      if (rawRecipes == null || rawRecipes.isEmpty) {
        setState(() {
          _isLoading = false;
          _notFound = true;
          areaRecipes = [];
        });
        return null;
      }
      List<Recipe> _filteredRecipes = rawRecipes.map<Recipe>((recipeMap) {
        return Recipe(
          id: recipeMap['idMeal'] ?? '',
          name: recipeMap['strMeal'] ?? '',
          category: '',
          area: area,
          imageUrl: recipeMap['strMealThumb'] ?? '',
          tags: '',
          instructions: '',
          ingredients: [],
        );
      }).toList();
      setState(() {
        areaRecipes = _filteredRecipes;
        _isLoading = false;
        _notFound = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _notFound = true;
        areaRecipes = [];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    List<Recipe> recipesToShow;
    if (widget.isFromCategory) {
      recipesToShow = categoryRecipes;
    } else if (widget.isFromArea) {
      recipesToShow = areaRecipes;
    } else {
      recipesToShow = detailedRecipes;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffeff1f7),
        appBar: AppBar(
          backgroundColor: const Color(0xffeff1f7),
          title: widget.isFromCategory || widget.isFromArea
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
                      setState(() {
                        detailedRecipes = [];
                        categoryRecipes = [];
                        areaRecipes = [];
                      });
                      _search(text);
                    },
                    initialText: widget.searchText,
                  ),
              ),
        ),
        body: _isLoading
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
          itemCount: recipesToShow.length,
          itemBuilder: (context, index) {
            final recipe = recipesToShow[index];
            if (widget.isFromCategory || widget.isFromArea) {
              return RecipeFilteredItem(recipe: recipe);
            } else {
              return RecipeItem(recipe: recipe);
            }
          },
        ),
      ),
    );
  }
}