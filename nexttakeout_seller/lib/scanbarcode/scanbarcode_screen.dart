import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout_seller/order/order_item_model.dart';
import 'package:nexttakeout_seller/scanbarcode/index.dart';

class ScanbarcodeScreen extends StatefulWidget {
  const ScanbarcodeScreen({
    Key key,
    @required ScanbarcodeBloc scanbarcodeBloc,
  })  : _scanbarcodeBloc = scanbarcodeBloc,
        super(key: key);

  final ScanbarcodeBloc _scanbarcodeBloc;

  @override
  ScanbarcodeScreenState createState() {
    return ScanbarcodeScreenState();
  }
}

class ScanbarcodeScreenState extends State<ScanbarcodeScreen> {
  ScanbarcodeScreenState();

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
    widget._scanbarcodeBloc.initStream();
    return BlocBuilder<ScanbarcodeBloc, ScanbarcodeState>(
        bloc: widget._scanbarcodeBloc,
        builder: (
          BuildContext context,
          ScanbarcodeState currentState,
        ) {
          if (currentState is UnScanbarcodeState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorScanbarcodeState) {
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
          if (currentState is InScanbarcodeState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: StreamBuilder(
                          stream:
                              widget._scanbarcodeBloc.allTodayOrderItems.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<OrderItemModel>> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Scrollbar(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var tempOrderItems = snapshot.data[index];
                                  return Column(
                                    children: <Widget>[
                                      Text('Menu Ordered: ' +
                                          tempOrderItems.menuOrdered.name),
                                      Text('Pickup Date: ' +
                                          tempOrderItems.pickupDate.toString()),
                                      Text('Status: ' +
                                          tempOrderItems.orderStatus)
                                    ],
                                  );
                                },
                              ),
                            );
                          })),
                  
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
    widget._scanbarcodeBloc.add(LoadScanbarcodeEvent(isError));
  }
}
