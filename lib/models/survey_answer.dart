import 'package:shared_preferences/shared_preferences.dart';
class SurveyAnswer {
  SurveyAnswer({required this.isVegan, required this.area});
  final bool isVegan;
  final String area;
  static Future<void> saveToPrefs(SurveyAnswer answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('survey_isVegan', answer.isVegan);
    await prefs.setString('survey_area', answer.area);
  }
  static Future<SurveyAnswer?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isVegan = prefs.getBool('survey_isVegan');
    final area = prefs.getString('survey_area');
    if (isVegan != null && area != null) {
      return SurveyAnswer(isVegan: isVegan, area: area);
    }
    return null;
  }
}