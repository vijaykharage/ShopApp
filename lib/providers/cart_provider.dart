import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final String authToken;
  Map<String, CartItem> _items = {};

  CartProvider(this.authToken, this._items);

  final String url =
      'https://shopapp-flutter-77f85-default-rtdb.firebaseio.com/';

  Map<String, CartItem> get items {
    return _items;
  }

  Future<Map<String, CartItem>> getItems() async {
    try {
      await _getCartItemsFromServer();
      return _items;
    } catch (error) {
      throw error;
    }
  }

  double get totalAmount {
    double _totalAmount = 0;
    _items.forEach((key, cartItem) {
      _totalAmount += (cartItem.price * cartItem.quantity);
    });
    return _totalAmount;
  }

  Future<void> addToCart(CartItem cartItem) async {
    try {
      await _addToCartOnServer(cartItem);

      if (_items.containsKey(cartItem.id)) {
        _items.update(
          cartItem.id,
          (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
          ),
        );
      } else {
        _items.putIfAbsent(
          cartItem.id,
          () => CartItem(
            id: DateTime.now().toString(),
            title: cartItem.title,
            quantity: cartItem.quantity,
            price: cartItem.price,
          ),
        );
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void undoAddAction(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(id, (existingProduct) {
        return CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          price: existingProduct.price,
          quantity: existingProduct.quantity - 1,
        );
      });
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  Future<void> _addToCartOnServer(CartItem cartItem) async {
    final response = await http.post(
      url + 'cart.json?auth=$authToken',
      body: convert.jsonEncode(
        {
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw HttpException('Can\'t add product to cart');
    }
    return response;
  }

  Future<void> _getCartItemsFromServer() async {
    final response = await http.get(url + 'cart.json?auth=$authToken');

    if (response.statusCode >= 400) {
      throw HttpException('Can\'t fetch cart items');
    }

    final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
    CartItem _tempItem;
    for (final key in json.keys) {
      final value = json[key] as Map<String, dynamic>;
      _tempItem = CartItem(
        id: key,
        title: value['title'],
        price: value['price'],
        quantity: value['quantity'],
      );
      _items.putIfAbsent(key, () => _tempItem);
    }
    return response;
  }
}
