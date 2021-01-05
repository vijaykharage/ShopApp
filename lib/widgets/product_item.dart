import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

import '../screens/product_details_screen.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),

          /// Consumer always listens to changes
          /// here provider listener is false so whole widget will not
          /// been rebuild. but this favorite button will.
          leading: Consumer<ProductProvider>(
            builder: (ctx, productProvider, _) {
              return IconButton(
                color: Theme.of(context).accentColor,
                icon: product.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  productProvider.toggleFavorite(product.id);
                },
              );
            },
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              final cartItem = CartItem(
                id: product.id,
                title: product.title,
                price: product.price,
                quantity: 1,
              );
              cartProvider.addToCart(cartItem);
              prefix0.Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartProvider.undoAddAction(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[],
        ),
      ),
    );
  }
}
