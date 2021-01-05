import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.productId, this.title, this.price, this.quantity);
  @override
  Widget build(BuildContext context) {
    print('building cart item');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Dismissible(
        background: Container(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)),
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showAlert(context);
        },
        onDismissed: (direction) {
          Provider.of<CartProvider>(context).items.remove(productId);
        },
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$ $price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }

  Future<bool> showAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This action will delete this item from cart.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('NO'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text('YES'),
            ),
          ],
        );
      },
    );
  }
}
