import 'package:flutter/material.dart';

import '../screens/add_product_screen.dart';

class ManageProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;

  ManageProductsItem(this.id, this.title, this.imageUrl, this.deleteHandler);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteHandler,
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
