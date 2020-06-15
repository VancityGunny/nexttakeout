import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nexttakeout/pickup_order/index.dart';
import 'package:nexttakeout/order/order_item_model.dart';

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
    widget._pickupOrderBloc.initStream();
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
            return StreamBuilder(
              stream: widget._pickupOrderBloc.allOrderItems.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderItemModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.length == 0) {
                  return Text(
                      'You have no meal scheduled. Try purchasing meal packages and start ordering today.');
                }
                var currentOrderItems = snapshot.data;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: currentOrderItems.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          Container(
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    new DateFormat.E().format(
                                        currentOrderItems[index].pickupDate),
                                    style: TextStyle(fontSize: 25.0),
                                  ),
                                  Text(
                                    currentOrderItems[index]
                                        .pickupDate
                                        .day
                                        .toString() + ' ' + new DateFormat.MMM().format(
                                        currentOrderItems[index].pickupDate),
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                          Card(
                              child: Column(
                            children: <Widget>[
                              Image.network(currentOrderItems[index]
                                  .menuOrdered
                                  .photoUrl),
                              Text('Order Date:' +
                                  currentOrderItems[index]
                                      .orderedDate
                                      .toString()),
                              Text('Pickup Date:' +
                                  currentOrderItems[index]
                                      .pickupDate
                                      .toString()),
                              Text('Order Item:' +
                                  currentOrderItems[index].menuOrdered.name),
                              Text(
                                'Order Status:' +
                                    currentOrderItems[index].orderStatus,
                                style: TextStyle(
                                    color: Colors.black,
                                    backgroundColor: getOrderColors(
                                        currentOrderItems[index].orderStatus)),
                              ),
                            ],
                          ))
                        ],
                      );
                    });
              },
            );
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

  MaterialColor getOrderColors(String orderStatus) {
    switch (orderStatus) {
      case 'Pending':
        return Colors.yellow;
      case 'Ready':
        return Colors.green;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
