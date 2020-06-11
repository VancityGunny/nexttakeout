import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/pickup_order/index.dart';

class PickupOrderScreen extends StatefulWidget {
  const PickupOrderScreen({
    Key key,
    @required PickupOrderBloc pickupOrderBloc,
  })  : _pickupOrderBloc = pickupOrderBloc,
        super(key: key);

  final PickupOrderBloc _pickupOrderBloc;

  @override
  PickupOrderScreenState createState() {
    return PickupOrderScreenState();
  }
}

class PickupOrderScreenState extends State<PickupOrderScreen> {
  PickupOrderScreenState();

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
    return BlocBuilder<PickupOrderBloc, PickupOrderState>(
        bloc: widget._pickupOrderBloc,
        builder: (
          BuildContext context,
          PickupOrderState currentState,
        ) {
          if (currentState is UnPickupOrderState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorPickupOrderState) {
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
           if (currentState is InPickupOrderState) {
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
    widget._pickupOrderBloc.add(LoadPickupOrderEvent(isError));
  }
}
