import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../assets/products_data.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final String url =
      'https://shopapp-flutter-77f85-default-rtdb.firebaseio.com/';
  List<Product> _items = []; //PRODUCTS_DATA.toList();

  List<Product> get items {
    return _items;
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get filteredProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await _addProductToServer(product);
      if (response.statusCode == 200) {
        final newProduct = Product(
          id: convert.jsonDecode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        );
        _items.insert(0, newProduct);
        notifyListeners();
      } else {
        print('Not able to add product');
        throw HttpException('Not able to add product');
      }
    } catch (error) {
      throw error;
    }
  }

  void toggleFavorite(String id) {
    final index = _items.indexWhere((product) {
      return product.id == id;
    });
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _items[index] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _deleteProductFromServer(id);

      _items.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  /// This is not so good way to call web services
  /// use async await as used in _addProductToServer
  /// This is just for demo purpose.
  Future<void> getProductsFromServer() {
    return http.get(url + 'products.json').then((response) {
      final resp = convert.jsonDecode(response.body) as Map<String, dynamic>;
      _items.clear();

      for (String key in resp.keys) {
        final value = resp[key] as Map<String, dynamic>;
        final product = Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: (value['price'] as double),
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        );
        _items.add(product);
        notifyListeners();
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<http.Response> _addProductToServer(Product product) async {
    try {
      final response = await http.post(
        url + 'products.json',
        body: convert.jsonEncode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      print(response.body);
      print(response.statusCode);
      return response;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _deleteProductFromServer(String id) async {
    try {
      final response = await http.delete(url + 'products/$id.json');
      print(response.body);
      print(response.statusCode);
      return response;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
