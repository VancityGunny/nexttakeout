import 'package:flutter/material.dart';
import 'package:nexttakeout_seller/order/index.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/order';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _orderBloc = OrderBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: OrderScreen(orderBloc: _orderBloc),
    );
  }
}
