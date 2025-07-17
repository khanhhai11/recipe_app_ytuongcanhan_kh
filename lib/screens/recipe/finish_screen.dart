import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/recipe.dart';
import '../../router.dart';
import '../../services/supabase_comments_and_ratings.dart';
class FinishScreen extends StatefulWidget {
  const FinishScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<FinishScreen> createState() => _FinishScreenState();
}
class _FinishScreenState extends State<FinishScreen> {
  double _rating = 0.0;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadExistingFeedback();
  }
  Future<void> _loadExistingFeedback() async {
    final data = await SupabaseCommentsAndRatingsService.fetchUserFeedback(widget.recipe.id);
    if (data != null) {
      setState(() {
        _rating = (data['ratings'] as num?)?.toDouble() ?? 0.0;
        _controller.text = data['comments'] ?? '';
      });
    }
    setState(() => _isLoading = false);
  }
  Future<void> _submit() async {
    try {
      await SupabaseCommentsAndRatingsService.submitFeedback(
        recipeId: widget.recipe.id,
        rating: _rating,
        comment: _controller.text.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanks for your feedback!')),
        );
        context.goNamed(Screen.main_navigation.name);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF475D)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.recipe.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                fadeInDuration: const Duration(milliseconds: 500),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Congrats on finishing your ${widget.recipe.name}, how does it taste?",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'My rating:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30,
                  unratedColor: Colors.grey.shade300,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0xFFFF475D),
                    size: 30,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  updateOnDrag: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'My review:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              cursorColor: const Color(0xFFFF475D),
              decoration: InputDecoration(
                hintText: 'Leave a comment/suggestion.',
                hintStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFFF475D), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFFF475D)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.goNamed(Screen.main_navigation.name);
                    },
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: const Text(
                      'Home',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF475D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      'Send',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}