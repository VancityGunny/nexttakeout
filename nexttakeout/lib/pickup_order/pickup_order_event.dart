import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/pickup_order/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PickupOrderEvent {
  Stream<PickupOrderState> applyAsync(
      {PickupOrderState currentState, PickupOrderBloc bloc});
  final PickupOrderRepository _pickupOrderRepository = PickupOrderRepository();
}

class UnPickupOrderEvent extends PickupOrderEvent {
  @override
  Stream<PickupOrderState> applyAsync({PickupOrderState currentState, PickupOrderBloc bloc}) async* {
    yield UnPickupOrderState(0);
  }
}

class LoadPickupOrderEvent extends PickupOrderEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadPickupOrderEvent';

  LoadPickupOrderEvent(this.isError);

  @override
  Stream<PickupOrderState> applyAsync(
      {PickupOrderState currentState, PickupOrderBloc bloc}) async* {
    try {
      yield UnPickupOrderState(0);
      await Future.delayed(Duration(seconds: 1));
      _pickupOrderRepository.test(isError);
      yield InPickupOrderState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadPickupOrderEvent', error: _, stackTrace: stackTrace);
      yield ErrorPickupOrderState(0, _?.toString());
    }
  }
}
