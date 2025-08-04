import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:recipe_app/router.dart';
import '../providers/favourite_provider.dart';
import '../services/supabase_comments_and_ratings.dart';
class SquaredRecipeItem extends StatefulWidget {
  const SquaredRecipeItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<SquaredRecipeItem> createState() => _SquaredRecipeItemState();
}
class _SquaredRecipeItemState extends State<SquaredRecipeItem> {
  double _averageRating = 0.0;
  @override
  void initState() {
    super.initState();
    _loadAverageRating();
  }
  Future<void> _loadAverageRating() async {
    final average = await SupabaseCommentsAndRatingsService.fetchAverageRating(widget.recipe.id);
    if (mounted) {
      setState(() {
        _averageRating = average;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(Screen.recipe.name, extra: widget.recipe);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Consumer<FavouritesProvider>(
                      builder: (context, favouritesProvider, _) {
                        final isFav = favouritesProvider.isFavourite(widget.recipe.id);
                        return Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 18,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.recipe.name,
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
                  widget.recipe.category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.public, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.recipe.area,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.star, size: 14, color: Colors.amber[700]),
                    const SizedBox(width: 2),
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}