import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/order_item.dart';

import '../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isFetchingOrders = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isFetchingOrders = true;
    });
    final orderProvder = Provider.of<OrderProvider>(context, listen: false);
    orderProvder.getOrdersFromServer().then((_) {
      setState(() {
        isFetchingOrders = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvder = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text('Orders'),
      ),
      drawer: DrawerWidget(),
      body: isFetchingOrders
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            )
          : orderProvder.orders.isEmpty
              ? Center(
                  child: Text('No orders found.'),
                )
              : Container(
                  child: ListView.builder(
                    itemBuilder: (_, index) => OrderItem(
                      orderProvder.orders[index],
                    ),
                    itemCount: orderProvder.orders.length,
                  ),
                ),
    );
  }
}
