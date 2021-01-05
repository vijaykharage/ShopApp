import 'package:flutter/material.dart';

import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flipkart'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text("Shop"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Orders"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Manage Products"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(ManageProductsScreen.routeName);
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
