import 'package:flutter/material.dart';
class RecipeItemTrait extends StatelessWidget {
  const RecipeItemTrait({super.key, required this.icon, required this.string});
  final IconData icon;
  final String string;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 5),
        Text(string[0].toUpperCase() + string.substring(1).toLowerCase(), style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
