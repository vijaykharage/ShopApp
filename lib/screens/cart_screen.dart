import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    print('cart screen is building');
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text('Total: '),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      orderProvider.placeOrder(
                        cartProvider.items.values.toList(),
                        cartProvider.totalAmount,
                      );
                      cartProvider.clearCart();
                    },
                    child: Text('PLACE ORDER'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final cart = cartProvider.items.values.toList()[index];
                  return CartItem(
                      cart.id,
                      cartProvider.items.keys.toList()[index],
                      cart.title,
                      cart.price,
                      cart.quantity);
                },
                itemCount: cartProvider.items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
