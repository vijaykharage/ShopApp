import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add_product_screen';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var _firstTimeLoading = true;
  var _isAddingProduct = false;
  var _priceFocusNode = FocusNode();
  var _imageFocusNode = FocusNode();

  var _imageUrltextController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  var _existingProduct = Product(
    id: null,
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  final urlRegEx =
      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

  @override
  void initState() {
    _imageFocusNode.addListener(_updateView);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firstTimeLoading) {
      _firstTimeLoading = false;
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _existingProduct =
            Provider.of<ProductProvider>(context).findById(productId);
        _imageUrltextController.text = _existingProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.title;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text('Add Product'),
      ),
      body: _isAddingProduct
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                          color: textStyle.color,
                        ),
                        initialValue: _existingProduct.title,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).nextFocus();

                          /// can also use this
                          //FocusScope.of(context).requestFocus(priceFocusNode);
                        },
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: value,
                            price: _existingProduct.price,
                            description: _existingProduct.description,
                            imageUrl: _existingProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Title can not be empty';
                          }
                          return null; // null means no error
                        },
                      ),
                      TextFormField(
                        style: textStyle,
                        initialValue: _existingProduct.price.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).nextFocus();

                          /// can also use this
                          //FocusScope.of(context).requestFocus(imageFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price can not be empty';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter valid price';
                          } else if (double.parse(value) <= 0) {
                            return 'Enter price greater than zero';
                          }
                          return null; // null means no error
                        },
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: _existingProduct.title,
                            price: double.parse(value),
                            description: _existingProduct.description,
                            imageUrl: _existingProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        style: textStyle,
                        initialValue: _existingProduct.description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description can not be empty';
                          }
                          return null; // null means no error
                        },
                        onSaved: (value) {
                          _existingProduct = Product(
                            id: _existingProduct.id,
                            title: _existingProduct.title,
                            price: _existingProduct.price,
                            description: value,
                            imageUrl: _existingProduct.imageUrl,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(top: 8, right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: _imageUrltextController.text.isEmpty
                                ? const Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      'Enter Image URL',
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: FittedBox(
                                      child: Image.network(
                                          _imageUrltextController.text),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              style: textStyle,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                                labelStyle: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              focusNode: _imageFocusNode,
                              controller: _imageUrltextController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Image URL can not be empty';
                                }
                                var urlPattern =
                                    r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                                var result =
                                    RegExp(urlPattern, caseSensitive: false)
                                        .hasMatch(value);
                                if (!result) {
                                  return 'Please enter valid URL';
                                }
                                return null; // null means no error
                              },
                              onSaved: (value) {
                                _existingProduct = Product(
                                  id: _existingProduct.id,
                                  title: _existingProduct.title,
                                  price: _existingProduct.price,
                                  description: _existingProduct.description,
                                  imageUrl: value,
                                );
                              },
                              onEditingComplete: () {
                                _addProduct(context);
                              },

                              /// This is required for future flutter version
                              /// the listener mechanism will not work.
                              // onEditingComplete: () {
                              //   setState(() {});
                              // },
                            ),
                          ),
                        ],
                      ),
                      RaisedButton(
                        color: Colors.red[800],
                        child: Text(
                          'SUBMIT',
                          style: textStyle,
                        ),
                        onPressed: () {
                          _addProduct(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateView);
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrltextController.dispose();
    super.dispose();
  }

  void _updateView() {
    if (_imageUrltextController.text.isEmpty) {
      return;
    }
    var result = RegExp(urlRegEx, caseSensitive: false)
        .hasMatch(_imageUrltextController.text);
    if (!result) {
      return;
    }
    print('setting state');
    setState(() {});
  }

  Future<void> _addProduct(BuildContext ctx) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isAddingProduct = true;
    });

    if (_existingProduct.id != null) {
      setState(() {
        _isAddingProduct = true;
      });
      final productProvider = Provider.of<ProductProvider>(ctx, listen: false);
      await productProvider.updateProduct(_existingProduct.id, _existingProduct).then(
        (_) {
          setState(
            () {
              _isAddingProduct = false;
            },
          );
          Navigator.of(ctx).pop();
        },
      );
    } else {
      final productProvider = Provider.of<ProductProvider>(ctx, listen: false);
      try {
        setState(() {
          _isAddingProduct = true;
        });
        await productProvider.addProduct(_existingProduct);
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: Text('Something went wrong!'),
              content: Text(
                  'Product can not be added at this time. Please try later.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        setState(
          () {
            _isAddingProduct = false;
          },
        );
        Navigator.of(context).pop();
      }
    }
  }
}
