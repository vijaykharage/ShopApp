import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../screens/error_screen.dart';
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
    _showAlert(ctx).then((isOkayToDelete) {
      Navigator.of(ctx).pop();
      if (isOkayToDelete) {
        productProvider
            .deleteProduct(productProvider.items[index].id)
            .then((_) {
          print('Product Deleted.');
        }).catchError((error) {
          print('Not able to delete product rn.');
        });
      }
    });
  }

  Future<void> _refreshProducts(BuildContext ctx) async {
    try {
      await Provider.of<ProductProvider>(ctx, listen: false)
          .getProductsFromServer(true);
    } catch (error) {
      Navigator.of(ctx).pushReplacementNamed(ErrorScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final productProvider = Provider.of<ProductProvider>(context);
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
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              //final productProvider = snapshot.data as ProductProvider;
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Container(
                  child: Consumer<ProductProvider>(
                    builder: (ctx, productProvider, _) => ListView.builder(
                      itemBuilder: (_, index) {
                        return Column(
                          children: <Widget>[
                            ManageProductsItem(
                              productProvider.items[index].id,
                              productProvider.items[index].title,
                              productProvider.items[index].imageUrl,
                              () => _deleteProduct(
                                  context, productProvider, index),
                            ),
                            Divider(
                                color: Theme.of(context).textTheme.body1.color),
                          ],
                        );
                      },
                      itemCount: productProvider.items.length,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName);
            } else {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            }
          },
        ));
  }
}
