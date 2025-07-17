import 'dart:convert';
import 'package:http/http.dart' as http;
class APINetworkHelper{
  APINetworkHelper(this.uri);
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
  APINetworkHelper networkHelper = APINetworkHelper(uri);
  var randomData = await networkHelper.getData();
  return randomData['meals']?[0];
}
Future searchRecipeById(String id) async {
  var uri = Uri.https('www.themealdb.com','/api/json/v1/1/lookup.php', {'i': id});
  APINetworkHelper networkHelper = APINetworkHelper(uri);
  var recipeData = await networkHelper.getData();
  return recipeData;
}
Future searchRecipeByName(String name) async {
  var uri = Uri.https('www.themealdb.com','/api/json/v1/1/search.php', {'s': name});
  APINetworkHelper networkHelper = APINetworkHelper(uri);
  var recipeData = await networkHelper.getData();
  return recipeData;
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