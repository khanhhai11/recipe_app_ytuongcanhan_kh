import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/recipe.dart';
import 'package:recipe_app/router.dart';
class SuggestionMiniItem extends StatelessWidget {
  const SuggestionMiniItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(Screen.recipe.name, extra: recipe),
      borderRadius: BorderRadius.circular(16),
      splashColor: Color(0xFFFF475D).withOpacity(0.3),
      highlightColor: Color(0xFFFF475D).withOpacity(0.1),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF475D),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: recipe.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${recipe.category} • ${recipe.area}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}