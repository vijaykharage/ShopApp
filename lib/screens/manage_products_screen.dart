import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product_screen.dart';

import '../providers/product_provider.dart';

import '../widgets/manage_products_item.dart';
import '../widgets/drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage_products';

  Future<bool> _showAlert(BuildContext ctx) {
    return showCupertinoDialog(
      context: ctx,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Do you really want to delete this?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('YES'),
              ),
            ),
            CupertinoDialogAction(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('NO'),
              ),
            ),
          ],
        );
      },
    );
  }

  _deleteProduct(BuildContext ctx, ProductProvider productProvider, int index) {
    _showAlert(ctx).then(
      (isOkayToDelete) {
        if (isOkayToDelete) {
          return productProvider.deleteProduct(productProvider.items[index].id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Container(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Column(
              children: <Widget>[
                ManageProductsItem(
                  productProvider.items[index].id,
                  productProvider.items[index].title,
                  productProvider.items[index].imageUrl,
                  () => _deleteProduct(context, productProvider, index),
                ),
                Divider(color: Theme.of(context).textTheme.body1.color),
              ],
            );
          },
          itemCount: productProvider.items.length,
        ),
      ),
    );
  }
}
