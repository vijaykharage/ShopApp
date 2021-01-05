import 'package:flutter/material.dart';

import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Theme.of(context).textTheme.title.color);
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red[800],
            title: Image.asset('./lib/assets/images/tesla-logo.png'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.shopping_basket, color: textStyle.color),
                title: Text(
                  "Shop",
                  style: textStyle,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list, color: textStyle.color),
                title: Text(
                  "Orders",
                  style: textStyle,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit, color: textStyle.color),
                title: Text(
                  "Manage Products",
                  style: textStyle,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ManageProductsScreen.routeName);
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
