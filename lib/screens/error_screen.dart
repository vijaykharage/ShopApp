import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class ErrorScreen extends StatelessWidget {
  static const routeName = '/error_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        backgroundColor: Colors.red[800],
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: Text('Opps!! Something went wrong'),
      ),
    );
  }
}
