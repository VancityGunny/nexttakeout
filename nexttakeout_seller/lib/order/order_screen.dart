import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout_seller/order/index.dart';
import 'package:nexttakeout_seller/order/order_item_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key key,
    @required OrderBloc orderBloc,
  })  : _orderBloc = orderBloc,
        super(key: key);

  final OrderBloc _orderBloc;

  @override
  OrderScreenState createState() {
    return OrderScreenState();
  }
}

class OrderScreenState extends State<OrderScreen> {
  OrderScreenState();

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
    widget._orderBloc.initStream();
    return BlocBuilder<OrderBloc, OrderState>(
        bloc: widget._orderBloc,
        builder: (
          BuildContext context,
          OrderState currentState,
        ) {
          if (currentState is UnOrderState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorOrderState) {
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
          if (currentState is InOrderState) {
            return Column(children: <Widget>[
              Text(
                'Purchased Packages',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: widget._orderBloc.allPaidOrders.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<OrderModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Scrollbar(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              var tempOrder = snapshot.data[index];
                              return Column(
                                children: <Widget>[
                                  Text('Product: ' + tempOrder.productCode),
                                  Text('Price: ' + tempOrder.price.toString()),
                                  Text('Purchase Date: ' +
                                      tempOrder.purchaseDate.toString())
                                ],
                              );
                            },
                          ),
                        );
                      })),
              Text(
                'Current Orders',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: widget._orderBloc.allOrderItems.stream,
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
                                  Text('Menu Ordered: ' + tempOrderItems.menuOrdered.name),
                                  Text('Pickup Date: ' + tempOrderItems.pickupDate.toString()),
                                  Text('Status: ' +
                                      tempOrderItems.orderStatus)
                                ],
                              );
                            },
                          ),
                        );
                      })),
            ]);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load([bool isError = false]) {
    widget._orderBloc.add(LoadOrderEvent(isError));
  }
}
