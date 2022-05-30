import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task/models/product.dart';
import 'package:task/models/state.dart';

Future<List<Product>> getAllProductList() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/MuazzezA/jsonForTask/main/products.json'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['products'];
    List<Product>? products = <Product>[];
    products = jsonResponse.map((e) => Product.fromJson(e)).toList();
    return products;
  } else {
    throw Exception('Failed to load json from API');
  }
}

Future<List<States>> getAllStateList() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/MuazzezA/jsonForTask/main/states.json'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['states'];
    List<States>? states = <States>[];
    states = jsonResponse.map((e) => States.fromJson(e)).toList();
    return states;
  } else {
    throw Exception('Failed to load json from API');
  }
}
