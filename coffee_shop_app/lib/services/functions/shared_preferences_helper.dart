import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> addProductToSharedPreferences(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? productsString = prefs.getString('products');
    List<String> products = productsString != null
        ? List<String>.from(jsonDecode(productsString))
        : <String>[];
    // Add the new product to the list
    if (!products.contains(id)) {
      while (products.length >= 8) {
        products.removeLast();
      }
    } else {
      products.removeWhere((element) => element == id);
    }
    products.insert(0, id);
    // Save the updated list back to SharedPreferences
    String updatedProductsString = jsonEncode(products);
    await prefs.setString('products', updatedProductsString);
  }

  static Future<List<String>> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? productsString = prefs.getString('products');
    return productsString != null
        ? List<String>.from(jsonDecode(productsString))
        : <String>[];
  }
}
