import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  ProductGrid(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products =
        showFavorites ? productsData.filteredProducts : productsData.items;

    return GridView.builder(
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
