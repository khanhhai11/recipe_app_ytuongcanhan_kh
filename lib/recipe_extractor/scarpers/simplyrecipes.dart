import 'package:html/dom.dart';
import 'package:recipe_app/recipe_extractor/recipe_extractor_models/scarper.dart';
// TODO: MAKE SIMPLY RECIPE RECIPE_EXTRACTOR WORK
class Simplyrecipes implements Scarper {
  Document? document;
  @override
  String? recipeName() {
    Element? titleEl = document!.getElementById("recipe-block__header_1-0");
    if (titleEl != null) {
      return titleEl.text;
    }
    return null;
  }
  @override
  List<String>? ingredients() {
    List<Element> ingredientsElList =
        document!.querySelectorAll(".structured-ingredients__list-item");
    List<String> ingredients = [];
    for (var ingredientEl in ingredientsElList) {
      ingredients.add(ingredientEl.text.replaceAll(RegExp(r"\s+"), " ").trim());
    }
    return ingredients;
  }
  @override
  List<String>? instructions() {
    List<Node> instructionsElList =
        document!.querySelectorAll("#structured-project__steps_1-0 p");
    List<String> instructions = [];
    for (var instructionEl in instructionsElList) {
      instructions.add(instructionEl.text!.trim());
    }
    return instructions;
  }
  @override
  String get host => "simplyrecipes.com";
  @override
  set pageDocument(Document document) {
    this.document = document;
  }
  @override
  String? servings() {
    Element? container =
        document!.querySelector(".project-meta__recipe-serving");
    return container?.children.lastOrNull?.text;
  }
  @override
  String? image() {
    return document!.querySelector(".primary-image__image")?.attributes["src"];
  }
  @override
  String? calories() {
    for (var row in document!.querySelectorAll(".nutrition-info__table--row")) {
      if (row.children.length == 2 && row.children[1].text.trim() == "Calories") {
        return row.children[0].text.trim();
      }
    }
    return null;
  }
  @override
  String? fat() {
    for (var row in document!.querySelectorAll(".nutrition-info__table--row")) {
      if (row.children.length == 2 && row.children[1].text.trim() == "Fat") {
        return row.children[0].text.trim();
      }
    }
    return null;
  }
  @override
  String? carbs() {
    for (var row in document!.querySelectorAll(".nutrition-info__table--row")) {
      if (row.children.length == 2 && row.children[1].text.trim() == "Carbs") {
        return row.children[0].text.trim();
      }
    }
    return null;
  }
  @override
  String? protein() {
    for (var row in document!.querySelectorAll(".nutrition-info__table--row")) {
      if (row.children.length == 2 && row.children[1].text.trim() == "Protein") {
        return row.children[0].text.trim();
      }
    }
    return null;
  }
  @override
  String? prepTime() {
    for (var element in document!.querySelectorAll(".meta-text")) {
      if (element.querySelector(".meta-text__label")?.text.trim() == "Prep Time") {
        return element.querySelector(".meta-text__data")?.text.trim();
      }
    }
    return null;
  }
  @override
  String? cookTime() {
    for (var element in document!.querySelectorAll(".meta-text")) {
      if (element.querySelector(".meta-text__label")?.text.trim() == "Cook Time") {
        return element.querySelector(".meta-text__data")?.text.trim();
      }
    }
    return null;
  }
}