import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/order_provider.dart';
import './providers/cart_provider.dart';
import './providers/product_provider.dart';

import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/add_product_screen.dart';

void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          canvasColor: Colors.white,
        ),
        routes: {
          '/': (_) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          ManageProductsScreen.routeName: (_) => ManageProductsScreen(),
          AddProductScreen.routeName: (_) => AddProductScreen()
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (_) => ProductsOverviewScreen());
        },
      ),
    );
  }
}
