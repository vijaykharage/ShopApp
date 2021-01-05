import 'package:flutter/foundation.dart';

import '../assets/products_data.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = PRODUCTS_DATA.toList();

  List<Product> get items {
    return _items;
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get filteredProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    // _items.add(newProduct);
    _items.insert(0, newProduct);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _items.indexWhere((product) {
      return product.id == id;
    });
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _items[index] = newProduct;
    }
    notifyListeners();
  }

  deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
