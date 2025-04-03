import 'package:go_router/go_router.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/introduction_screen.dart';
import 'package:recipe_app/screens/recipe_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';
import 'models/recipe.dart';
enum Screen { home, search, recipe }
final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'introduction',
      builder: (context, state) => IntroductionScreen(),
      routes: [
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: Screen.search.name,
              name: Screen.search.name,
              builder: (context, state) => SearchScreen(searchText: state.extra as String),
              routes: [
                GoRoute(
                  path: Screen.recipe.name,
                  name: Screen.recipe.name,
                  builder: (context, state) => RecipeScreen(recipe: state.extra as Recipe),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
