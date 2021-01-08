import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/error_screen.dart';

import '../providers/product_provider.dart';
import './product_item.dart';

class ProductGrid extends StatefulWidget {
  final bool showFavorites;

  ProductGrid(this.showFavorites);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  ProductProvider productsData;
  var _isFetchedData = false;

  @override
  void didChangeDependencies() {
    if (!_isFetchedData) {
      productsData = Provider.of<ProductProvider>(context);
      productsData.getProductsFromServer().then((_) {
        setState(() {
          _isFetchedData = true;
        });
      }).catchError((error) {
        /// currently not using this dialog as we are routing 
        /// to error route
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return CupertinoAlertDialog(
        //         title: Text('Something went wrong!'),
        //         content: Text('Please try after some time.'),
        //         actions: <Widget>[
        //           FlatButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //               setState(() {
        //                 _isFetchedData = true;
        //               });
        //             },
        //             child: Text('OK'),
        //           ),
        //         ],
        //       );
        //     });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ErrorScreen(),
          ),
        );
      }).then((_) {
        setState(() {
          _isFetchedData = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.showFavorites
        ? productsData.filteredProducts
        : productsData.items;

    return !_isFetchedData
        ? Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 3 / 2,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              /// nested listener for each product
              /// used to notify provider if product marked as favorite.
              /// use value() constructor on list or grid instead of create/builder
              /// so that flutter will not cause bugs while reusing list cells.
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              );
            },
          );
  }
}
