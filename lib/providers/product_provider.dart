import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart' as customException;

class ProductProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = []; //PRODUCTS_DATA.toList();

  ProductProvider(this.authToken, this.userId, this._items);

  final String url =
      'https://shopapp-flutter-77f85-default-rtdb.firebaseio.com/';

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

  Future<void> toggleFavorite(String id) async {
    try {
      await _toggleFavoriteOnServer(id);
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await _updateProductOnServer(id, newProduct);
    } catch (error) {
      print(error);
    }
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
  Future<void> getProductsFromServer([bool fetchUserData = false]) async {
    final filterString =
        fetchUserData ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    await http
        .get(url + 'products.json?auth=$authToken&$filterString')
        .then((response) async {
      final resp = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (resp == null) {
        return;
      }

      final _response =
          await http.get(url + 'favoriteProducts/$userId.json?auth=$authToken');
      final favouriteResponse = convert.jsonDecode(_response.body);
      _items.clear();

      for (String key in resp.keys) {
        print(resp[key]);
        final value = resp[key] as Map<String, dynamic>;
        final product = Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: (value['price'] as double),
          imageUrl: value['imageUrl'],
          isFavorite: favouriteResponse == null
              ? false
              : favouriteResponse[key] ?? false,
        );
        _items.add(product);
        notifyListeners();
      }
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<http.Response> _addProductToServer(Product product) async {
    try {
      final response = await http.post(
        url + 'products.json?auth=$authToken',
        body: convert.jsonEncode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            //'isFavorite': product.isFavorite,
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
    final index = _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[index];
    try {
      final response = await http.delete(url + 'products/$id?auth=$authToken');
      if (response.statusCode >= 400) {
        // _items.insert(index, existingProduct);
        // notifyListeners();
        throw customException.HttpException('Product could not be deleted!');
      }
      existingProduct = null;
      return response;
    } catch (error) {
      throw error;
    }
  }

  Future<void> _updateProductOnServer(String id, Product newProduct) async {
    await http.patch(
      url + 'products/$id.json?auth=$authToken',
      body: convert.jsonEncode(
        {
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );
  }

  Future<void> _toggleFavoriteOnServer(String id) async {
    final index = _items.indexWhere((product) {
      return product.id == id;
    });
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();

    final isFavorite = _items[index].isFavorite;

    // final response = await http.patch(
    //   url + 'products/$id.json?auth=$authToken',
    //   body: convert.jsonEncode({
    //     'isFavorite': isFavorite,
    //   }),
    // );

    final response = await http.put(
      url + '/favoriteProducts/$userId/$id.json?auth=$authToken',
      body: convert.jsonEncode(
        isFavorite,
      ),
    );

    if (response.statusCode >= 400) {
      _items[index].isFavorite = !_items[index].isFavorite;
      notifyListeners();
      throw customException.HttpException('Could not add to favorite.');
    }

    return response;
  }
}
