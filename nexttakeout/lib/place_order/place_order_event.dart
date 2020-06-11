import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/place_order/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlaceOrderEvent {
  Stream<PlaceOrderState> applyAsync(
      {PlaceOrderState currentState, PlaceOrderBloc bloc});
  final PlaceOrderRepository _placeOrderRepository = PlaceOrderRepository();
}

class UnPlaceOrderEvent extends PlaceOrderEvent {
  @override
  Stream<PlaceOrderState> applyAsync({PlaceOrderState currentState, PlaceOrderBloc bloc}) async* {
    yield UnPlaceOrderState(0);
  }
}

class LoadPlaceOrderEvent extends PlaceOrderEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadPlaceOrderEvent';

  LoadPlaceOrderEvent(this.isError);

  @override
  Stream<PlaceOrderState> applyAsync(
      {PlaceOrderState currentState, PlaceOrderBloc bloc}) async* {
    try {
      yield UnPlaceOrderState(0);
      await Future.delayed(Duration(seconds: 1));
      _placeOrderRepository.test(isError);
      yield InPlaceOrderState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadPlaceOrderEvent', error: _, stackTrace: stackTrace);
      yield ErrorPlaceOrderState(0, _?.toString());
    }
  }
}
