import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/models/survey_answer.dart';
import 'package:recipe_app/router.dart';
import 'package:recipe_app/services/network.dart';
class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});
  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}
class _SurveyScreenState extends State<SurveyScreen> {
  bool? _isVegan;
  String? _selectedArea;
  List<String> _areas = [];
  @override
  void initState() {
    super.initState();
    _loadAreas();
    _loadSurveyAnswer();
  }
  Future<void> _loadAreas() async {
    try {
      final data = await fetchAreas();
      setState(() {
        _areas = List<String>.from(data.map((a) => a['strArea']));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading areas')),
      );
    }
  }
  Future<void> _loadSurveyAnswer() async {
    final answer = await SurveyAnswer.loadFromPrefs();
    if (answer != null) {
      if (mounted) {
        context.goNamed(Screen.main_navigation.name);
      }
    } else {
      setState(() {
        _isVegan = null;
        _selectedArea = null;
      });
    }
  }
  Future<void> _submitSurvey() async {
    if (_isVegan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select if you are vegan.')),
      );
      return;
    }
    if (_selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your area.')),
      );
      return;
    }
    final answer = SurveyAnswer(isVegan: _isVegan!, area: _selectedArea!);
    await SurveyAnswer.saveToPrefs(answer);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Survey saved successfully!')),
    );
    context.goNamed(Screen.main_navigation.name);
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
                      onChanged: (value) =>
                          setState(() => _selectedArea = value),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
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