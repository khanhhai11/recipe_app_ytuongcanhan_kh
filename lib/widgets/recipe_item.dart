import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/widgets/recipe_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/recipe.dart';
import '../router.dart';
class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context){
              return Center(
                child: Theme(
                  data: ThemeData(
                    progressIndicatorTheme: ProgressIndicatorThemeData(
                      color: Color(0xFFff475D),
                    ),
                  ),
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
          await Future.delayed(Duration(seconds: 2));
          if (context.mounted) {
            // Navigator.of(context).pop();
            context.goNamed(Screen.recipe.name, extra: recipe);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0xFFff475D), width: 4),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: recipe.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  height: 76,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          recipe.name,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RecipeItemTrait(icon: Icons.timer, string: recipe.duration),
                            RecipeItemTrait(icon: Icons.shopping_bag, string: recipe.complexity.name)
                          ],
                        ),
                      ],
                    ),
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
