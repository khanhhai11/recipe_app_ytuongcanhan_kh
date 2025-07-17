import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/models/survey_answer.dart';
import 'package:recipe_app/router.dart';
import 'package:recipe_app/services/supabase_survey.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/areas.dart';
class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});
  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}
class _SurveyScreenState extends State<SurveyScreen> {
  bool? _isVegan;
  String? _selectedArea;
  final List<String> _areas = Areas;
  @override
  void initState() {
    super.initState();
    _checkIfSurveyExists();
  }
  Future<void> _checkIfSurveyExists() async {
    try {
      final answer = await SupabaseSurveyService.fetchCurrentUserAnswer();
      if (answer != null && mounted) {
        context.goNamed(Screen.main_navigation.name);
      }
    } catch (e) {
      _showSnackBar('Failed to check survey data');
    }
  }
  Future<void> _submitSurvey() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showSnackBar('You must be logged in to submit the survey.');
      return;
    }
    if (_isVegan == null) {
      _showSnackBar('Please select if you are vegan.');
      return;
    }
    if (_selectedArea == null) {
      _showSnackBar('Please select your area.');
      return;
    }
    final answer = SurveyAnswer(isVegan: _isVegan!, area: _selectedArea!);
    try {
      await SupabaseSurveyService.saveOrUpdateSurvey(answer);
      _showSnackBar('Survey saved successfully!');
      if (mounted) {
        context.goNamed(Screen.main_navigation.name);
      }
    } catch (e) {
      _showSnackBar('Error saving survey: ${e.toString()}');
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xffeff1f7);
    const Color primaryColor = Color(0xffff475d);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        title: const Text(
          'Survey',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you vegan?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Yes'),
                      activeColor: primaryColor,
                      value: true,
                      groupValue: _isVegan,
                      onChanged: (value) => setState(() => _isVegan = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('No'),
                      activeColor: primaryColor,
                      value: false,
                      groupValue: _isVegan,
                      onChanged: (value) => setState(() => _isVegan = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_isVegan != null) ...[
                const Text(
                  'Where are you from?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedArea,
                      hint: const Text('Select an area'),
                      isExpanded: true,
                      items: _areas.map((area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedArea = value),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitSurvey,
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}