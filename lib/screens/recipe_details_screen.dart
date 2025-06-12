import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:recipe_app/router.dart';
import '../functions/fetch_recipe_by_id.dart';
import '../models/recipe.dart';
class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}
class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  int _currentStep = 0;
  late Recipe recipe;
  bool _isLoading = false;
  bool _loadFailed = false;
  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    if (recipe.instructions.trim().isEmpty || recipe.ingredients.isEmpty) {
      _fetchDetailedRecipe();
    }
  }
  Future<void> _fetchDetailedRecipe() async {
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });
    final detailed = await fetchRecipeById(recipe.id);
    if (detailed != null) {
      setState(() {
        recipe = detailed;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
    }
  }
  Widget _buildErrorUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Could not load full recipe.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF475D),
              ),
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  List<String> _splitInstructions(String rawInstructions) {
    return rawInstructions
        .split(RegExp(r'(?<=[.?!])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .where((s) => !RegExp(r'^\d+\.?$').hasMatch(s))
        .map((s) => s.endsWith('.') ? s : '$s.')
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    final instructions = _splitInstructions(recipe.instructions);
    if (_isLoading) {
      return Scaffold(
        body: Center(
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
                'Please wait, loading recipe...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFff475D),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_loadFailed) return _buildErrorUI();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop){
        if(!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ingredients & Instructions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🧂 Ingredients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF475D),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.map(
                        (ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '📋 Instructions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFFFF475D),
                  ),
                ),
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < instructions.length - 1) {
                      setState(() => _currentStep++);
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    }
                  },
                  onStepTapped: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  controlsBuilder: (context, details) {
                    final isLastStep = _currentStep == instructions.length - 1;
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (isLastStep) {
                              context.goNamed(Screen.finish.name,
                                  extra: recipe);
                            } else {
                              details.onStepContinue?.call();
                            }
                          },
                          child: Text(isLastStep ? 'Finish' : 'Next'),
                        ),
                        const SizedBox(width: 8),
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                      ],
                    );
                  },
                  steps: List.generate(instructions.length, (index) {
                    return Step(
                      title: Text('Step ${index + 1}'),
                      content: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (child, animation, secondaryAnimation) =>
                            SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.vertical,
                              child: child,
                            ),
                        child: Container(
                          key: ValueKey(index),
                          alignment: Alignment.centerLeft,
                          color: const Color(0xffeff1f7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                instructions[index],
                                style: const TextStyle(fontSize: 16, height: 1.4),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      isActive: _currentStep >= index,
                      state: _currentStep > index
                          ? StepState.complete
                          : StepState.indexed,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
