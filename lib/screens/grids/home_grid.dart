import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/functions/fetch_final_random_recipe.dart';
import 'package:recipe_app/widgets/search_recipe_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
import 'package:recipe_app/models/recipe.dart';
import '../../functions/load_survey_and_fetch_suggestions.dart';
import '../../models/survey_answer.dart';
import '../../providers/favourite_provider.dart';
import '../../widgets/settings_button.dart';
import '../../widgets/suggestion_mini_item.dart';
class HomeGrid extends StatefulWidget {
  const HomeGrid({super.key});
  @override
  State<HomeGrid> createState() => _HomeGridState();
}
class _HomeGridState extends State<HomeGrid> {
  List<Recipe> _suggestionRecipes = [];
  bool _isLoadingSuggestions = true;
  SurveyAnswer? _surveyAnswer;
  @override
  void initState() {
    super.initState();
    _loadSurveyAndFetchSuggestions();
  }
  Future<void> _loadSurveyAndFetchSuggestions() async {
    final (answer, suggestions) = await loadSurveyAndFetchSuggestions(context);
    if (!mounted) return;
    setState(() {
      _surveyAnswer = answer;
      _suggestionRecipes = suggestions;
      _isLoadingSuggestions = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff1f7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffeff1f7),
        title: const Text(
          'Hungry?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Random Recipe!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Click the button below to fetch a random recipe.',
                            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF475D),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                                onPressed: () async {
                                  final recipe = await fetchFinalRandomRecipe(context);
                                  if (recipe != null && mounted) {
                                    context.goNamed(Screen.recipe.name, extra: recipe);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Randomized Recipe: ${recipe.name}')),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Generate',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.casino, color: Colors.black),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: SettingsButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Find a recipe for yourself in RecipeBox and do it!\nLots of quality recipes are waiting for you!',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 22),
                SearchRecipeBar(
                  onSearch: (text) async {
                    context.goNamed(
                      Screen.search.name,
                      extra: {
                        'searchText': text.toString(),
                        'isFromArea': false,
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/recipebox_banner.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Suggestion recipe:',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        context.goNamed(Screen.all_suggestions.name, extra: _suggestionRecipes);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFF475D),
                      ),
                      child: const Text(
                        'View All ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: _isLoadingSuggestions
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF475D),
                    ),
                  )
                      : _suggestionRecipes.isEmpty
                      ? const Center(child: Text('No suggestions available.'))
                      : ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      scrollbars: false,
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _suggestionRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _suggestionRecipes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SuggestionMiniItem(recipe: recipe),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}