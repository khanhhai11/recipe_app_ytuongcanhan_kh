import 'package:html/dom.dart';
import 'package:recipe_app/recipe_extractor/recipe_extractor_models/scarper.dart';
// TODO: MAKE ALLRECIPES RECIPE_EXTRACTOR WORK
class Allrecipes implements Scarper {
  Document? document;
  @override
  String? recipeName() {
    Element? titleElement = document!.querySelector("h1.article-heading");
    if (titleElement != null) {
      return titleElement.text;
    }
    return null;
  }
  @override
  List<String>? ingredients() {
    return document!
        .querySelectorAll(".mm-recipes-structured-ingredients__list-item p")
        .map((ingredientEl) => ingredientEl.text.trim())
        .toList();
  }
  @override
  List<String>? instructions() {
    return document!
        .querySelectorAll("#mm-recipes-steps__content_1-0 li p.mntl-sc-block-html")
        .map((instructionEl) => instructionEl.text.trim())
        .toList();
  }
  @override
  String get host => "allrecipes.com";
  @override
  set pageDocument(Document document) {
    this.document = document;
  }
  @override
  String? servings() {
    var servingsElement = document!
        .querySelector(".mm-recipes-details__label:contains('Servings') + .mm-recipes-details__value");
    return servingsElement?.text.trim();
  }
  @override
  String? image() {
    var imageElement = document!.querySelector(".universal-image__image");
    return imageElement?.attributes["data-src"];
  }
  @override
  String? calories() {
    var caloriesElement = document!
        .querySelector(".mm-recipes-nutrition-facts-summary__table-cell:contains('Calories')")
        ?.previousElementSibling;
    return caloriesElement?.text.trim();
  }
  @override
  String? fat() {
    var fatElement = document!
        .querySelector(".mm-recipes-nutrition-facts-summary__table-cell:contains('Fat')")
        ?.previousElementSibling;
    return fatElement?.text.trim();
  }
  @override
  String? carbs() {
    var carbsElement = document!
        .querySelector(".mm-recipes-nutrition-facts-summary__table-cell:contains('Carbs')")
        ?.previousElementSibling;
    return carbsElement?.text.trim();
  }
  @override
  String? protein() {
    var proteinElement = document!
        .querySelector(".mm-recipes-nutrition-facts-summary__table-cell:contains('Protein')")
        ?.previousElementSibling;
    return proteinElement?.text.trim();
  }
  @override
  String? prepTime() {
    var prepTimeElement = document!
        .querySelector(".mm-recipes-details__label:contains('Prep Time') + .mm-recipes-details__value");
    return prepTimeElement?.text.trim();
  }
  @override
  String? cookTime() {
    var cookTimeElement = document!
        .querySelector(".mm-recipes-details__label:contains('Cook Time') + .mm-recipes-details__value");
    return cookTimeElement?.text.trim();
  }
}
