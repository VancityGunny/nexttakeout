import 'package:flutter/material.dart';
import 'package:nexttakeout/pickup_order/index.dart';

class PickupOrderPage extends StatefulWidget {
  static const String routeName = '/pickupOrder';

  @override
  _PickupOrderPageState createState() => _PickupOrderPageState();
}

class _PickupOrderPageState extends State<PickupOrderPage> {
  final _pickupOrderBloc = PickupOrderBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PickupOrder'),
      ),
      body: PickupOrderScreen(pickupOrderBloc: _pickupOrderBloc),
    );
  }
}
