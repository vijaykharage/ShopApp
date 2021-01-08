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
          child: FadeInImage.assetNetwork(
            placeholder: './lib/assets/images/placeholder.jpg',
            image: product.imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: MediaQuery.of(context).orientation == Orientation.landscape
              ? Text(
                  product.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 400 ? 10 : 15),
                )
              : Container(),

          /// Consumer always listens to changes
          /// here provider listener is false so whole widget will not
          /// been rebuild. but this favorite button will.
          leading: Consumer<ProductProvider>(
            builder: (ctx, productProvider, _) {
              return IconButton(
                iconSize: 20.0,
                color: Theme.of(context).primaryColor,
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
            iconSize: 20.0,
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
        header: GridTileBar(
            //backgroundColor: Colors.black.withOpacity(0.2),
            ),
      ),
    );
  }
}
