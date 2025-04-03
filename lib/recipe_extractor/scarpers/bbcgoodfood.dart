import 'package:html/dom.dart';
import 'package:recipe_app/recipe_extractor/recipe_extractor_models/scarper.dart';
class Bbcgoodfood implements Scarper {
  Document? document;
  @override
  String? recipeName() {
    List<Node> titlesList = document!.getElementsByTagName("h1");
    if (titlesList.isNotEmpty) {
      return titlesList[0].text;
    }
    return null;
  }
  @override
  List<String>? ingredients() {
    List<Element> ingredientsElList =
        document!.querySelectorAll(".ingredients-list__item");
    List<String> ingredients = [];
    for (var ingredientEl in ingredientsElList) {
      ingredients.add(ingredientEl.text.replaceAll(RegExp(r"\s+"), " ").trim());
    }
    return ingredients;
  }
  @override
  List<String>? instructions() {
    List<Node> instructionsElList =
        document!.querySelectorAll(".method-steps__list-item");
    List<String> instructions = [];
    for (var instructionEl in instructionsElList) {
      var instructionContent = instructionEl.children[1];
      instructions.add(instructionContent.text.trim());
    }
    return instructions;
  }
  @override
  String get host => "bbcgoodfood.com";
  @override
  set pageDocument(Document document) {
    this.document = document;
  }
  @override
  String? servings() {
    List<Element> container =
        document!.getElementsByClassName("icon-with-text__children");
    if (container.length >= 3) {
      return container[2].text;
    }
    return null;
  }
  @override
  String? image() {
    return document!
        .querySelector(".post-header__image-container .image__img")
        ?.attributes["src"];
  }
  @override
  String? prepTime() {
    List<Node> prepTimeList = document!.querySelectorAll(".icon-with-text__children .list-item time");
    if (prepTimeList.isNotEmpty) {
      return prepTimeList[0].text?.trim();
    }
    return null;
  }
  @override
  String? cookTime() {
    List<Node> cookTimeList = document!.querySelectorAll(".icon-with-text__children .list-item time");
    if (cookTimeList.length > 1) {
      return cookTimeList[1].text?.trim();
    }
    return null;
  }
  @override
  String? calories() {
    List<Element> caloriesList = document!.querySelectorAll('.nutrition-list__item');
    if (caloriesList.isNotEmpty) {
      String caloriesText = caloriesList[0].text.trim();
      RegExp caloriesRegex = RegExp(r"(\d+\.?\d*)");
      Match? match = caloriesRegex.firstMatch(caloriesText);
      return match?.group(0);
    }
    return null;
  }
  @override
  String? fat() {
    List<Element> fatList = document!.querySelectorAll('.nutrition-list__item');
    if (fatList.length > 1) {
      String fatText = fatList[1].text.trim();
      RegExp fatRegex = RegExp(r"(\d+\.?\d*)g");
      Match? match = fatRegex.firstMatch(fatText);
      return match?.group(0);
    }
    return null;
  }
  @override
  String? carbs() {
    List<Element> carbsList = document!.querySelectorAll('.nutrition-list__item');
    if (carbsList.length > 3) {
      String carbsText = carbsList[3].text.trim();
      RegExp carbsRegex = RegExp(r"(\d+\.?\d*)g");
      Match? match = carbsRegex.firstMatch(carbsText);
      return match?.group(0);
    }
    return null;
  }
  @override
  String? protein() {
    List<Element> proteinList = document!.querySelectorAll('.nutrition-list__item');
    if (proteinList.length > 6) {
      String proteinText = proteinList[6].text.trim();
      RegExp proteinRegex = RegExp(r"(\d+\.?\d*)g");
      Match? match = proteinRegex.firstMatch(proteinText);
      return match?.group(0);
    }
    return null;
  }
}
