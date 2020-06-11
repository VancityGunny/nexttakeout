import 'package:flutter/material.dart';
import 'package:nexttakeout/payment/index.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = '/payment';
  final String _businessId;
  PaymentPage(this._businessId);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _paymentBloc = PaymentBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: PaymentScreen(widget._businessId, paymentBloc: _paymentBloc),
    );
  }
}
