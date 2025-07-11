import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_app/models/survey_answer.dart';
class SupabaseSurveyService {
  static final _client = Supabase.instance.client;
  static Future<SurveyAnswer?> fetchCurrentUserAnswer() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final response = await _client
        .from('recipe_app_survey_answers')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
    if (response == null) return null;
    return SurveyAnswer.fromMap(response);
  }
  static Future<void> saveOrUpdateSurvey(SurveyAnswer answer) async {
    final userId = _client.auth.currentUser?.id;
    final username = _client.auth.currentUser?.userMetadata?['display_name'];
    debugPrint(userId);
    if (userId == null) throw Exception('No user logged in');
    final response = await _client.from('recipe_app_survey_answers').upsert({
      'user_id': userId,
      'username': username,
      'isVegan': answer.isVegan,
      'area': answer.area,
    }).select();
    print('Upsert response: $response');
  }
}