import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/recipe.dart';
import '../router.dart';
class RecipeFilteredItem extends StatelessWidget {
  const RecipeFilteredItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    final infoParts = <String>[];
    if (recipe.category.isNotEmpty) infoParts.add('Category: ${recipe.category}');
    if (recipe.area.isNotEmpty) infoParts.add('Area: ${recipe.area}');
    final infoText = infoParts.isNotEmpty ? infoParts.join(' • ') : 'Unknown Category/Area';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.goNamed(Screen.recipe.name, extra: recipe);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFff475D), width: 4),
          ),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Hero(
                  tag: recipe.name,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: recipe.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        recipe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        infoText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}