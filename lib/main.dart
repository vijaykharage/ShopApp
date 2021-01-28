import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/order_provider.dart';
import './providers/cart_provider.dart';
import './providers/product_provider.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/add_product_screen.dart';
import './screens/error_screen.dart';

void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (_, authProvider, previoudProduct) => ProductProvider(
            authProvider.token,
            authProvider.userId,
            previoudProduct == null ? [] : previoudProduct.items,
          ),
          // create: (_) => ProductProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          update: (_, authProvider, previousCart) => CartProvider(
            authProvider.token,
            previousCart == null ? {} : previousCart.items,
          ),
          // create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (_, authProvider, previousOrder) => OrderProvider(
            authProvider.token,
            authProvider.userId,
            previousOrder == null ? [] : previousOrder.orders,
          ),
          // create: (_) => OrderProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.white,
            fontFamily: 'Lato',
            canvasColor: Colors.black,
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(color: Colors.white),
                body1: TextStyle(color: Colors.white60),
                body2: TextStyle(color: Colors.black)),
          ),
          home: authProvider.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authProvider.autoLogin(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else {
                      return AuthScreen();
                    }
                  }),
          routes: {
            //'/': authProvider.isAuth ? (_) => ProductsOverviewScreen() : (_) => AuthScreen(),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            ManageProductsScreen.routeName: (_) => ManageProductsScreen(),
            AddProductScreen.routeName: (_) => AddProductScreen()
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (_) => ErrorScreen());
          },
        ),
      ),
    );
  }
}
