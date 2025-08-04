import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_favourites.dart';
class FavouritesProvider extends ChangeNotifier {
  final Set<String> _favourites = {};
  bool isFavourite(String id) => _favourites.contains(id);
  Set<String> get favourites => _favourites;
  FavouritesProvider() {
    loadFavourites();
  }
  Future<void> loadFavourites() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || _favourites.isNotEmpty) return;
    print('[FAV] User: ${user.id}, loading favourites...');
    final fetched = await SupabaseFavouritesService.fetchFavourites();
    _favourites
      ..clear()
      ..addAll(fetched);
    notifyListeners();
  }
  Future<void> toggleFavourite(String recipeId) async {
    if (_favourites.contains(recipeId)) {
      await SupabaseFavouritesService.removeFromFavourites(recipeId);
      _favourites.remove(recipeId);
    } else {
      await SupabaseFavouritesService.addToFavourites(recipeId);
      _favourites.add(recipeId);
    }
    notifyListeners();
  }
}