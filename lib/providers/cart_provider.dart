import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  double get totalAmount {
    double _totalAmount = 0;
    _items.forEach((key, cartItem) {
      _totalAmount += (cartItem.price * cartItem.quantity);
    });
    return _totalAmount;
  }

  void addToCart(CartItem cartItem) {
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
}
