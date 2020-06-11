import 'package:flutter/material.dart';
import 'package:nexttakeout/business/index.dart';

class BusinessPage extends StatefulWidget {
  static const String routeName = '/business';

  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final _businessBloc = BusinessBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business'),
      ),
      body: BusinessScreen(businessBloc: _businessBloc),
    );
  }
}
