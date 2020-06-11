import 'package:flutter/material.dart';
import 'package:nexttakeout_seller/scanbarcode/index.dart';

class ScanbarcodePage extends StatefulWidget {
  static const String routeName = '/scanbarcode';

  @override
  _ScanbarcodePageState createState() => _ScanbarcodePageState();
}

class _ScanbarcodePageState extends State<ScanbarcodePage> {
  final _scanbarcodeBloc = ScanbarcodeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanbarcode'),
      ),
      body: ScanbarcodeScreen(scanbarcodeBloc: _scanbarcodeBloc),
    );
  }
}
