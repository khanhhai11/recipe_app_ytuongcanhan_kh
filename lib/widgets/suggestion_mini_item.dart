import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/recipe.dart';
import '../providers/favourite_provider.dart';
import '../router.dart';
import '../services/supabase_comments_and_ratings.dart';
class SuggestionMiniItem extends StatefulWidget {
  const SuggestionMiniItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<SuggestionMiniItem> createState() => _SuggestionMiniItemState();
}
class _SuggestionMiniItemState extends State<SuggestionMiniItem> {
  double _averageRating = 0.0;
  bool _isLoading = true;
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
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(Screen.recipe.name, extra: widget.recipe),
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color(0xFFFF475D),
      highlightColor: const Color(0xFFFF475D),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF475D),
            width: 2,
          ),
          boxShadow: const [
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
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.recipe.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
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
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        _isLoading ? '...' : _averageRating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black,
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
                        widget.recipe.name,
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
                        '${widget.recipe.category} • ${widget.recipe.area}',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}