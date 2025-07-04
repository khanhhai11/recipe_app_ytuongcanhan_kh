import 'package:supabase_flutter/supabase_flutter.dart';
class SurveyAnswer {
  final bool isVegan;
  final String area;
  SurveyAnswer({required this.isVegan, required this.area});
  Map<String, dynamic> toMap(String userId) => {
    'user_id': userId,
    'isVegan': isVegan,
    'area': area,
  };
  static SurveyAnswer fromMap(Map<String, dynamic> map) {
    return SurveyAnswer(
      isVegan: map['isVegan'] as bool,
      area: map['area'] as String,
    );
  }
}
