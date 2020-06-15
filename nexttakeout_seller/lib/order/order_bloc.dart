import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/order/index.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;
import 'package:nexttakeout_seller/order/order_item_model.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // todo: check singleton for logic in project
  static final OrderBloc _orderBlocSingleton = OrderBloc._internal();
  StreamController orderController;
  final BehaviorSubject<List<OrderModel>> allPaidOrders =
      BehaviorSubject<List<OrderModel>>();

  StreamController orderItemsController;
  final BehaviorSubject<List<OrderItemModel>> allOrderItems =
      BehaviorSubject<List<OrderItemModel>>();

  factory OrderBloc() {
    return _orderBlocSingleton;
  }
  OrderBloc._internal();

  initStream() {
    orderItemsController = StreamController.broadcast();
    orderItemsController.addStream(Firestore.instance
        .collection('/businessOrders')
        .document(globals.currentBusinessId)
        .snapshots());
    orderItemsController.stream.listen((event) {
      DocumentSnapshot docs = event;
      if (docs.data != null) {
        var newOrderItemsList = new List<OrderItemModel>();
        event.data['orderItems'].forEach((f) {
          newOrderItemsList.add(OrderItemModel.fromJson(f));
        });
        allOrderItems.add(newOrderItemsList);
      }
    });

    orderController = StreamController.broadcast();
    orderController.addStream(Firestore.instance
        .collection('/businesses')
        .document(globals.currentBusinessId)
        .snapshots());
    orderController.stream.listen((event) {
      DocumentSnapshot docs = event;
      if (docs.data != null) {
        var newOrderList = new List<OrderModel>();
        event.data['orders'].forEach((f) {
          var tempOrder = OrderModel.fromJson(f);
          if (tempOrder.receiptNumber != null) {
            newOrderList.add(OrderModel.fromJson(f));
          }
        });
        this.allPaidOrders.add(newOrderList);
      }
    });
  }

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  OrderState get initialState => UnOrderState(0);

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'OrderBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
