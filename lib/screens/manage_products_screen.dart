import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product_screen.dart';

import '../providers/product_provider.dart';

import '../widgets/manage_products_item.dart';
import '../widgets/drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage_products';
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    Function _deleteProduct(int index) {
      print('index: $index');
      return productProvider.deleteProduct(productProvider.items[index].id);
    }

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
                  () => _deleteProduct(index),
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
