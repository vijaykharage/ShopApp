import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return _orders;
  }

  void placeOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
        amount: total,
        date: DateTime.now(),
        id: DateTime.now().toString(),
        products: cartItems,
      ),
    );
    notifyListeners();
  }
}
