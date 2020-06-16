import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/business/business_repository.dart';
import 'package:nexttakeout_seller/menu/index.dart';
import 'package:nexttakeout_seller/menu/menu_model.dart';
import 'package:nexttakeout_seller/order/index.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;
import 'package:nexttakeout_seller/order/order_item_model.dart';
import 'package:rxdart/rxdart.dart';

import 'package:collection/collection.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // todo: check singleton for logic in project
  static final OrderBloc _orderBlocSingleton = OrderBloc._internal();
  StreamController orderController;
  final BehaviorSubject<List<OrderModel>> allPaidOrders =
      BehaviorSubject<List<OrderModel>>();

  StreamController orderItemsController;

  final BehaviorSubject<List<OrderSummaryModel>> allOrdersByDay =
      BehaviorSubject<List<OrderSummaryModel>>();

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
        var newOrderItemsList = new List<OrderSummaryModel>();
        var newOrdersByDay =
            groupBy(event.data['orderItems'], (t) => t['pickupDate']);
        newOrdersByDay.entries.forEach((element) {
          var menuItemsBreakdown =
              groupBy(element.value, (e) => e['menuOrdered']['name']);
          List<OrderCountModel> orderBreakdown = new List<OrderCountModel>();
          menuItemsBreakdown.entries.forEach((tmpMenu) {
            orderBreakdown.add(new OrderCountModel(
                MenuModel.fromJson(tmpMenu.value.first['menuOrdered']), tmpMenu.value.length));
          });
          var newEntry =
              new OrderSummaryModel(element.key.toDate(), orderBreakdown);
          newOrderItemsList.add(newEntry);
        });
        newOrderItemsList.sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
        allOrdersByDay.add(newOrderItemsList);
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

class OrderSummaryModel {
  OrderSummaryModel(this.pickupDate, this.orders);
  DateTime pickupDate;
  List<OrderCountModel> orders;
}

class OrderCountModel {
  OrderCountModel(this.menu, this.quantity);
  MenuModel menu;
  int quantity;
}
