import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/order/order_item_model.dart';
import 'package:nexttakeout_seller/scanbarcode/index.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class ScanbarcodeBloc extends Bloc<ScanbarcodeEvent, ScanbarcodeState> {
  // todo: check singleton for logic in project
  static final ScanbarcodeBloc _scanbarcodeBlocSingleton =
      ScanbarcodeBloc._internal();
  factory ScanbarcodeBloc() {
    return _scanbarcodeBlocSingleton;
  }

  StreamController orderItemsController;
  final BehaviorSubject<List<OrderItemModel>> allTodayOrderItems =
      BehaviorSubject<List<OrderItemModel>>();

  ScanbarcodeBloc._internal();

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
        event.data['orderItems'].where((f) {
          DateTime pickupDate = f['pickupDate'].toDate();
          var today = DateTime.now();
          return (pickupDate.day == today.day &&
              pickupDate.month == today.month &&
              pickupDate.year == today.year);
        }).forEach((f) {
          // only add today order item
          newOrderItemsList.add(OrderItemModel.fromJson(f));
        });
        allTodayOrderItems.add(newOrderItemsList);
      }
    });
  }

  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  ScanbarcodeState get initialState => UnScanbarcodeState(0);

  @override
  Stream<ScanbarcodeState> mapEventToState(
    ScanbarcodeEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'ScanbarcodeBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
