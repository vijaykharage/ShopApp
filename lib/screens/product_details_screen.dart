import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_details_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                height: 300,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '\$ ${product.price}',
                style: const TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${product.description}',
                style: const TextStyle(color: Colors.white60, fontSize: 15.0),
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
