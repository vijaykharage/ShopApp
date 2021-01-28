import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Order> _orders = [];

  OrderProvider(this.authToken, this.userId, this._orders);

  final String url =
      'https://shopapp-flutter-77f85-default-rtdb.firebaseio.com/';

  List<Order> get orders {
    return _orders;
  }

  Future<void> placeOrder(List<CartItem> cartItems, double total) async {
    final timestamp = DateTime.now();
    try {
      final response = await _placeOrderOnServer(cartItems, total, timestamp);

      _orders.insert(
        0,
        Order(
          amount: total,
          date: timestamp,
          id: convert.jsonDecode(response.body)['name'],
          products: cartItems,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<http.Response> _placeOrderOnServer(
      List<CartItem> cartItems, double total, DateTime timestamp) async {
    final response = await http.post(
      url + 'orders/$userId.json?auth=$authToken',
      body: convert.jsonEncode(
        {
          'amount': total,
          'date': timestamp.toIso8601String(),
          'products': cartItems
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity,
                  })
              .toList()
        },
      ),
    );
    print(response.body);
    if (response.statusCode >= 400) {
      throw HttpException('Can\'t place order');
    }
    return response;
  }

  Future<void> getOrdersFromServer() async {
    final response = await http.get(url + 'orders/$userId.json?auth=$authToken');
    final List<Order> listOfOrders = [];
    final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (json == null) {
      return;
    }
    json.forEach((orderId, orderData) {
      final products = (orderData['products'] as List<dynamic>).map(
        (cartItem) {
          return CartItem(
            id: cartItem['id'],
            title: cartItem['title'],
            price: cartItem['price'],
            quantity: cartItem['quantity'],
          );
        },
      ).toList();
      listOfOrders.add(
        Order(
          id: orderId,
          amount: orderData['amount'],
          date: DateTime.parse(orderData['date']),
          products: products,
        ),
      );
    });
    _orders = listOfOrders.reversed.toList(); // show recent order at top
    notifyListeners();
  }
}
