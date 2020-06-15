import 'dart:async';
import 'dart:developer' as developer;
import 'package:nexttakeout/common/global_object.dart' as globals;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout/order/order_item_model.dart';
import 'package:nexttakeout/order/order_model.dart';
import 'package:nexttakeout/place_order/index.dart';
import 'package:rxdart/rxdart.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  // todo: check singleton for logic in project
  static final PlaceOrderBloc _placeOrderBlocSingleton =
      PlaceOrderBloc._internal();
  StreamController orderItemsController;
  final BehaviorSubject<List<OrderItemModel>> allOrderItems =
      BehaviorSubject<List<OrderItemModel>>();

  StreamController orderController;
  final BehaviorSubject<List<OrderModel>> availableOrders =
      BehaviorSubject<List<OrderModel>>();

  factory PlaceOrderBloc() {
    return _placeOrderBlocSingleton;
  }
  PlaceOrderBloc._internal();

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  initStream() {
    orderItemsController = StreamController.broadcast();
    orderItemsController.addStream(Firestore.instance
        .collection('/userOrders')
        .document(globals.currentUserId)
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
        .collection('/users')
        .document(globals.currentUserId)
        .snapshots());
    orderController.stream.listen((event) {
      DocumentSnapshot docs = event;
      if (docs.data != null) {
        var newOrderList = new List<OrderModel>();
        event.data['orders'].forEach((f) {
          var tempOrder = OrderModel.fromJson(f);
          if (tempOrder.receiptNumber != null &&  tempOrder.maxQuantity > tempOrder.usedQuantity) {
            newOrderList.add(OrderModel.fromJson(f));
          }
        });
        availableOrders.add(newOrderList);
      }
    });
  }

  @override
  PlaceOrderState get initialState => UnPlaceOrderState(0);

  @override
  Stream<PlaceOrderState> mapEventToState(
    PlaceOrderEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'PlaceOrderBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
