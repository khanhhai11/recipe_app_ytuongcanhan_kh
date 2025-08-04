import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseFavouritesService {
  static final _client = Supabase.instance.client;
  static Future<void> addToFavourites(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw 'User not logged in';
    await _client.from('recipe_app_user_favourites').insert({
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }
  static Future<void> removeFromFavourites(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw 'User not logged in';
    await _client
        .from('recipe_app_user_favourites')
        .delete()
        .eq('user_id', userId)
        .eq('recipe_id', recipeId);
  }
  static Future<List<String>> fetchFavourites() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from('recipe_app_user_favourites')
        .select('recipe_id')
        .eq('user_id', userId);
    return response.map<String>((e) => e['recipe_id'].toString()).toList();
  }
}