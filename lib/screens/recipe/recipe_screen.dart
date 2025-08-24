import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/services/supabase_comments_and_ratings.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/recipe.dart';
import '../../providers/favourite_provider.dart';
import '../../router.dart';
import 'dart:math';
import '../../widgets/comment_item.dart';
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}
class _RecipeScreenState extends State<RecipeScreen> {
  final List<String> summaries = [
    "This recipe combines fresh ingredients and simple cooking techniques to create a delicious and nutritious dish. It is easy to prepare and perfect for any occasion. Whether you're looking for a quick meal or a healthy option, this recipe is sure to satisfy.",
    "A flavorful and quick meal that blends savory ingredients with rich spices. Perfect for a weeknight dinner or a weekend gathering. You’ll love the balance of taste and texture in this recipe!",
    "This dish highlights the beauty of seasonal ingredients. Packed with nutrients and flavor, it’s a wholesome meal that’s both satisfying and light, making it an ideal choice for a nutritious lunch or dinner.",
    "A perfect blend of sweet and savory, this recipe delivers a mouthwatering experience. With minimal effort, you can enjoy a comforting and flavorful dish that everyone will love.",
    "Looking for a healthy yet delicious recipe? This one features ingredients that are both nutritious and full of flavor. It's great for anyone looking to eat clean without sacrificing taste.",
    "This recipe is a celebration of vibrant flavors. Combining fresh herbs and a variety of ingredients, it's a great way to enjoy a balanced meal. Quick to make and perfect for any time of day!"
  ];
  String _getRandomSummary() => summaries[Random().nextInt(summaries.length)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF1F7),
        title: Text(
          widget.recipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: Consumer<FavouritesProvider>(
              builder: (context, favouritesProvider, _) {
                favouritesProvider.loadFavourites();
                final isLiked = favouritesProvider.isFavourite(widget.recipe.id);
                return LikeButton(
                  isLiked: isLiked,
                  size: 28,
                  circleColor: const CircleColor(
                    start: Colors.pink,
                    end: Colors.pinkAccent,
                  ),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Colors.pink,
                    dotSecondaryColor: Colors.pinkAccent,
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.pink : Colors.grey,
                      size: 32,
                    );
                  },
                  onTap: (bool isCurrentlyLiked) async {
                    final recipeId = widget.recipe.id;
                    if (recipeId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This recipe cannot be favourited.')),
                      );
                      return isCurrentlyLiked;
                    }
                    await favouritesProvider.toggleFavourite(recipeId);
                    return !isCurrentlyLiked;
                  },
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.recipe.name,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.recipe.imageUrl,
                  fit: BoxFit.cover,
                  height: 265,
                  width: double.infinity,
                  fadeInDuration: const Duration(milliseconds: 500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.recipe.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (widget.recipe.category.isNotEmpty)
              _infoRow(Icons.category, 'Category', widget.recipe.category),
            if (widget.recipe.area.isNotEmpty)
              _infoRow(Icons.language, 'Area', widget.recipe.area),
            if (widget.recipe.tags.isNotEmpty)
              _infoRow(Icons.label, 'Tags', _formatTags(widget.recipe.tags)),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Summary: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\n${_getRandomSummary()}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.goNamed(Screen.details.name, extra: widget.recipe);
              },
              icon: const Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: const Text(
                'View Ingredients & Instructions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF475D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Comments:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: SupabaseCommentsAndRatingsService.fetchAllFeedback(widget.recipe.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text(
                    'Error loading comments',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  );
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Text(
                    'No comments yet 😐',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  );
                }
                return Column(
                  children: comments.map((c) {
                    final username = (c['username'] as String?)?.trim() ?? 'Anonymous';
                    final comment = (c['comments'] as String?)?.trim() ?? '';
                    final rating = (c['ratings'] is num)
                        ? (c['ratings'] as num).toDouble()
                        : 0.0;
                    return CommentItem(
                      username: username,
                      comment: comment,
                      rating: rating,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
  String _formatTags(String tags) {
    final regExp = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return tags
        .split(',')
        .map((tag) => tag.trim().replaceAllMapped(regExp, (m) => ' '))
        .join(', ');
  }
}