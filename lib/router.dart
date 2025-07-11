import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/screens/all_suggestions_screen.dart';
import 'package:recipe_app/screens/authentication/main_authentication_screen.dart';
import 'package:recipe_app/screens/authentication/reset_password_screen.dart';
import 'package:recipe_app/screens/authentication/sign_up_screen.dart';
import 'package:recipe_app/screens/grids/category_grid.dart';
import 'package:recipe_app/screens/grids/favourite_grid.dart';
import 'package:recipe_app/screens/finish_screen.dart';
import 'package:recipe_app/screens/introduction_screen.dart';
import 'package:recipe_app/screens/authentication/sign_in_screen.dart';
import 'package:recipe_app/screens/recipe_details_screen.dart';
import 'package:recipe_app/screens/recipe_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';
import 'package:recipe_app/screens/authentication/survey_screen.dart';
import 'models/recipe.dart';
import 'package:recipe_app/screens/grids/main_navigation_screen.dart';
enum Screen {
  introduction,
  main_auth,
  sign_in,
  sign_up,
  reset_password,
  survey,
  main_navigation,
  all_suggestions,
  category,
  favourite,
  search,
  recipe,
  details,
  finish,
}
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'introduction',
      builder: (context, state) => IntroductionScreen(),
      routes: [
        GoRoute(
          path: Screen.main_auth.name,
          name: Screen.main_auth.name,
          builder: (context, state) => MainAuthenticationScreen(),
          routes: [
            GoRoute(
              path: Screen.sign_in.name,
              name: Screen.sign_in.name,
              builder: (context, state) => const SignInScreen(),
            ),
            GoRoute(
              path: Screen.sign_up.name,
              name: Screen.sign_up.name,
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              path: Screen.reset_password.name,
              name: Screen.reset_password.name,
              builder: (context, state) => const ResetPasswordScreen(),
            ),
            GoRoute(
              path: Screen.survey.name,
              name: Screen.survey.name,
              builder: (context, state) => const SurveyScreen(),
            ),
            GoRoute(
              path: Screen.main_navigation.name,
              name: Screen.main_navigation.name,
              builder: (context, state) => const MainNavigationScreen(),
              routes: [
                GoRoute(
                  path: Screen.all_suggestions.name,
                  name: Screen.all_suggestions.name,
                  builder: (context, state) => AllSuggestionsScreen(recipes: state.extra as List<Recipe>),
                ),
                GoRoute(
                  path: Screen.search.name,
                  name: Screen.search.name,
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return SearchScreen(
                      searchText: extra['searchText'] as String,
                      isFromCategory: extra['isFromCategory'] ?? false,
                      isFromArea: extra['isFromArea'] ?? false,
                      isFromSuggestion: extra['isFromSuggestion'] ?? false,
                    );
                  },
                ),
                GoRoute(
                  path: Screen.recipe.name,
                  name: Screen.recipe.name,
                  builder: (context, state) => RecipeScreen(recipe: state.extra as Recipe),
                  routes: [
                    GoRoute(
                      path: Screen.details.name,
                      name: Screen.details.name,
                      builder: (context, state) => RecipeDetailsScreen(recipe: state.extra as Recipe),
                      routes: [
                        GoRoute(
                          path: Screen.finish.name,
                          name: Screen.finish.name,
                          builder: (context, state) => FinishScreen(recipe: state.extra as Recipe),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: Screen.category.name,
                  name: Screen.category.name,
                  builder: (context, state) => CategoryGrid(),
                ),
                GoRoute(
                  path: Screen.favourite.name,
                  name: Screen.favourite.name,
                  builder: (context, state) => FavouriteGrid(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);