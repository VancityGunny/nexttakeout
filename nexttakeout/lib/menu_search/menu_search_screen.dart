import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/menu_search/index.dart';

class MenuSearchScreen extends StatefulWidget {
  const MenuSearchScreen({
    Key key,
    @required MenuSearchBloc menuSearchBloc,
  })  : _menuSearchBloc = menuSearchBloc,
        super(key: key);

  final MenuSearchBloc _menuSearchBloc;

  @override
  MenuSearchScreenState createState() {
    return MenuSearchScreenState();
  }
}

class MenuSearchScreenState extends State<MenuSearchScreen> {
  MenuSearchScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuSearchBloc, MenuSearchState>(
        bloc: widget._menuSearchBloc,
        builder: (
          BuildContext context,
          MenuSearchState currentState,
        ) {
          if (currentState is UnMenuSearchState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorMenuSearchState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
           if (currentState is InMenuSearchState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.businesses.length.toString()),
                  Text('Flutter files: done'),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('throw error'),
                      onPressed: () => _load(true),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(),
          );
          
        });
  }

  void _load([bool isError = false]) {
    widget._menuSearchBloc.add(LoadMenuSearchEvent(isError));
  }
}
