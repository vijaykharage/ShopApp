import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/order_item.dart';

import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';
  @override
  Widget build(BuildContext context) {
    final orderProvder = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: DrawerWidget(),
      body: orderProvder.orders.isEmpty
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
