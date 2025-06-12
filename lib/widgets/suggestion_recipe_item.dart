import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import 'package:recipe_app/router.dart';
class SuggestionRecipeItem extends StatelessWidget {
  const SuggestionRecipeItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(Screen.recipe.name, extra: recipe);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            recipe.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.restaurant_menu, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  recipe.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.public, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  recipe.area,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}