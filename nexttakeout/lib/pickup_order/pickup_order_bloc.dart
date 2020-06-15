import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/common/global_object.dart' as globals;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout/order/order_item_model.dart';
import 'package:nexttakeout/pickup_order/index.dart';
import 'package:rxdart/rxdart.dart';

class PickupOrderBloc extends Bloc<PickupOrderEvent, PickupOrderState> {
  // todo: check singleton for logic in project
  static final PickupOrderBloc _pickupOrderBlocSingleton =
      PickupOrderBloc._internal();

  StreamController orderItemsController;
  final BehaviorSubject<List<OrderItemModel>> allOrderItems =
      BehaviorSubject<List<OrderItemModel>>();

  factory PickupOrderBloc() {
    return _pickupOrderBlocSingleton;
  }
  PickupOrderBloc._internal();

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
        newOrderItemsList.sort((a, b) => a.pickupDate.compareTo(b.pickupDate));

        allOrderItems.add(newOrderItemsList);
      }
    });
  }

  @override
  PickupOrderState get initialState => UnPickupOrderState(0);

  @override
  Stream<PickupOrderState> mapEventToState(
    PickupOrderEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'PickupOrderBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
