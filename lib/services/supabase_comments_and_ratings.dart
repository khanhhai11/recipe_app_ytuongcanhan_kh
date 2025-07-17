import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseCommentsAndRatingsService {
  static final _client = Supabase.instance.client;
  static Future<double> fetchAverageRating(String recipeId) async {
    final response = await _client
        .from('recipe_app_comments_and_ratings')
        .select('ratings')
        .eq('recipe_id', recipeId)
        .not('ratings', 'is', null);
    if (response.isEmpty) return 0.0;
    final ratings = response
        .map((r) => r['ratings'])
        .where((r) => r != null)
        .map((r) => (r as num).toDouble())
        .toList();
    final average = ratings.reduce((a, b) => a + b) / ratings.length;
    return double.parse(average.toStringAsFixed(1));
  }
  static Future<Map<String, dynamic>?> fetchUserFeedback(String recipeId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await _client
        .from('recipe_app_comments_and_ratings')
        .select('ratings, comments')
        .eq('recipe_id', recipeId)
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }
  static Future<void> submitFeedback({
    required String recipeId,
    required double rating,
    required String comment,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    final existing = await _client
        .from('recipe_app_comments_and_ratings')
        .select()
        .eq('user_id', user.id)
        .eq('recipe_id', recipeId)
        .maybeSingle();
    if (existing == null) {
      await _client.from('recipe_app_comments_and_ratings').insert({
        'user_id': user.id,
        'username': user.userMetadata?['display_name'] ?? 'Anonymous',
        'recipe_id': recipeId,
        'ratings': rating.toInt(),
        'comments': comment,
      });
    } else {
      await _client
          .from('recipe_app_comments_and_ratings')
          .update({
        'ratings': rating.toInt(),
        'comments': comment,
      }).eq('user_id', user.id).eq('recipe_id', recipeId);
    }
  }
}