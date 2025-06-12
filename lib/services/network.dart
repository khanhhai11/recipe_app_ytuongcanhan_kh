import 'dart:convert';
import 'package:http/http.dart' as http;
class NetworkHelper{
  NetworkHelper(this.uri);
  final Uri uri;
  getData() async {
    http.Response response = await http.get(uri);
    if (response.statusCode == 200){
      var data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
Future fetchRandomRecipe() async {
  var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/random.php');
  NetworkHelper networkHelper = NetworkHelper(uri);
  var randomData = await networkHelper.getData();
  return randomData['meals']?[0];
}
Future searchRecipeById(String id) async {
  var uri = Uri.https('www.themealdb.com','/api/json/v1/1/lookup.php', {'i': id});
  NetworkHelper networkHelper = NetworkHelper(uri);
  var recipeData = await networkHelper.getData();
  return recipeData;
}
Future searchRecipeByName(String name) async {
  var uri = Uri.https('www.themealdb.com','/api/json/v1/1/search.php', {'s': name});
  NetworkHelper networkHelper = NetworkHelper(uri);
  var recipeData = await networkHelper.getData();
  return recipeData;
}
Future fetchCategories() async {
  var uri = Uri.https('themealdb.com', '/api/json/v1/1/categories.php');
  NetworkHelper networkHelper = NetworkHelper(uri);
  var categoryData = await networkHelper.getData();
  return categoryData['categories'];
}
Future fetchAreas() async {
  var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/list.php', {'a': 'list'});
  NetworkHelper networkHelper = NetworkHelper(uri);
  var areaData = await networkHelper.getData();
  return areaData['meals'];
}
Future fetchRecipeByCategory(String category) async {
  var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/filter.php', {'c': category});
  final response = await http.get(uri);
  return json.decode(response.body);
}
Future fetchRecipeByArea(String area) async {
  var uri = Uri.https('www.themealdb.com', '/api/json/v1/1/filter.php', {'a': area});
  final response = await http.get(uri);
  return json.decode(response.body);
}