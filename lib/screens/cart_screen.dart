import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text('Cart'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Total: ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 100,
                    child: Chip(
                      label: FittedBox(
                        child: Text(
                          '\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                  ),
                  PlaceOrderButton(
                    cartProvider: cartProvider,
                    orderProvider: orderProvider,
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

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.cartProvider,
    @required this.orderProvider,
  }) : super(key: key);

  final CartProvider cartProvider;
  final OrderProvider orderProvider;

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrderButton> {
  var _isPlacingOrder = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      child: _isPlacingOrder
          ? CupertinoActivityIndicator(
              radius: 15,
            )
          : FlatButton(
              onPressed: widget.cartProvider.totalAmount <= 0
                  ? null
                  : () {
                      setState(() {
                        _isPlacingOrder = true;
                      });
                      widget.orderProvider
                          .placeOrder(
                        widget.cartProvider.items.values.toList(),
                        widget.cartProvider.totalAmount,
                      )
                          .then((_) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order Placed Successdully!!'),
                          ),
                        );
                        setState(() {
                          _isPlacingOrder = false;
                        });
                      });
                      widget.cartProvider.clearCart();
                    },
              child: Text('PLACE ORDER'),
            ),
    );
  }
}
