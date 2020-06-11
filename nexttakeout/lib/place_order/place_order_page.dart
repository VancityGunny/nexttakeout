import 'package:flutter/material.dart';
import 'package:nexttakeout/place_order/index.dart';

class PlaceOrderPage extends StatefulWidget {
  static const String routeName = '/placeOrder';

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final _placeOrderBloc = PlaceOrderBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlaceOrder'),
      ),
      body: PlaceOrderScreen(placeOrderBloc: _placeOrderBloc),
    );
  }
}
