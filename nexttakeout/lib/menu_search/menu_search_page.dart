import 'package:flutter/material.dart';
import 'package:nexttakeout/menu_search/index.dart';

class MenuSearchPage extends StatefulWidget {
  static const String routeName = '/menuSearch';

  @override
  _MenuSearchPageState createState() => _MenuSearchPageState();
}

class _MenuSearchPageState extends State<MenuSearchPage> {
  final _menuSearchBloc = MenuSearchBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MenuSearch'),
      ),
      body: MenuSearchScreen(menuSearchBloc: _menuSearchBloc),
    );
  }
}
