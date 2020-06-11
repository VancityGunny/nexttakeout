import 'package:flutter/material.dart';
import 'package:nexttakeout_seller/menu/index.dart';

class MenuPage extends StatefulWidget {
  static const String routeName = '/menu';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _menuBloc = MenuBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: MenuScreen(menuBloc: _menuBloc),
    );
  }
}
