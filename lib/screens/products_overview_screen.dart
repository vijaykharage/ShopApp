import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';

import '../providers/cart_provider.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/drawer.dart';

enum FilterEnum {
  ShowFav,
  ShowAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFilteredProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Image.asset('./lib/assets/images/tesla-logo.png'),
        actions: <Widget>[
          Consumer<CartProvider>(
            /// here cartChild referes to Consumer child: IconButton()
            builder: (_, cartProvider, iconButton) => Badge(
              child: iconButton,
              value: cartProvider.items.length.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FilterEnum.ShowFav,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterEnum.ShowAll,
              ),
            ],
            initialValue: FilterEnum.ShowAll,
            onSelected: (FilterEnum selectedValue) {
              setState(() {
                if (selectedValue == FilterEnum.ShowFav) {
                  _showFilteredProducts = true;
                } else {
                  _showFilteredProducts = false;
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ProductGrid(_showFilteredProducts),
      ),
    );
  }
}
