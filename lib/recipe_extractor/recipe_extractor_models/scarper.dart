import 'package:html/dom.dart';
abstract class Scarper {
  String? recipeName();
  List<String>? ingredients();
  List<String>? instructions();
  String? servings();
  String? image();
  String? calories();
  String? fat();
  String? carbs();
  String? protein();
  String? prepTime();
  String? cookTime();
  String get host;
  set pageDocument(Document document);
}
