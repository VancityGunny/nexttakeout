import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/place_order/index.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key key,
    @required PlaceOrderBloc placeOrderBloc,
  })  : _placeOrderBloc = placeOrderBloc,
        super(key: key);

  final PlaceOrderBloc _placeOrderBloc;

  @override
  PlaceOrderScreenState createState() {
    return PlaceOrderScreenState();
  }
}

class PlaceOrderScreenState extends State<PlaceOrderScreen> {
  PlaceOrderScreenState();

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
    return BlocBuilder<PlaceOrderBloc, PlaceOrderState>(
        bloc: widget._placeOrderBloc,
        builder: (
          BuildContext context,
          PlaceOrderState currentState,
        ) {
          if (currentState is UnPlaceOrderState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorPlaceOrderState) {
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
           if (currentState is InPlaceOrderState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
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
    widget._placeOrderBloc.add(LoadPlaceOrderEvent(isError));
  }
}
