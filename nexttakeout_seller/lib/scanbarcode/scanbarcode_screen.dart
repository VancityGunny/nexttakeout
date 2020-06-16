import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout_seller/order/index.dart';
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
                  Text(
                    'Today\'s Pickup',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
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
                                  return Card(
                                    color: getOrderColor(
                                        tempOrderItems.orderStatus),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Menu Ordered: ' +
                                            tempOrderItems.menuOrdered.name),
                                        Text('Customer: ' +
                                            tempOrderItems.customerName),
                                        Text('Status: ' +
                                            tempOrderItems.orderStatus),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Visibility(
                                                visible: (tempOrderItems
                                                        .orderStatus ==
                                                    'Pending'),
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    // mark ready
                                                    OrderRepository orderRepo =
                                                        new OrderRepository();
                                                    tempOrderItems.orderStatus =
                                                        'Ready';
                                                    orderRepo
                                                        .updateSpecificOrderItem(
                                                            tempOrderItems);
                                                  },
                                                  child: Text('Mark as Ready'),
                                                )),
                                            Visibility(
                                              visible:
                                                  (tempOrderItems.orderStatus ==
                                                      'Ready'),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  //  mark completed
                                                  OrderRepository orderRepo =
                                                      new OrderRepository();
                                                  tempOrderItems.orderStatus =
                                                      'Completed';
                                                  orderRepo
                                                      .updateSpecificOrderItem(
                                                          tempOrderItems);
                                                },
                                                child:
                                                    Text('Mark as Completed'),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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

  getOrderColor(String orderStatus) {
    switch (orderStatus) {
      case 'Pending':
        return Colors.yellow;
      case 'Ready':
        return Colors.green;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }
}
