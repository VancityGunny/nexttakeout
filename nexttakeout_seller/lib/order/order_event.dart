import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout_seller/order/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderEvent {
  Stream<OrderState> applyAsync(
      {OrderState currentState, OrderBloc bloc});
  final OrderRepository _orderRepository = OrderRepository();
}

class UnOrderEvent extends OrderEvent {
  @override
  Stream<OrderState> applyAsync({OrderState currentState, OrderBloc bloc}) async* {
    yield UnOrderState(0);
  }
}

class LoadOrderEvent extends OrderEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadOrderEvent';

  LoadOrderEvent(this.isError);

  @override
  Stream<OrderState> applyAsync(
      {OrderState currentState, OrderBloc bloc}) async* {
    try {
      yield UnOrderState(0);
      await Future.delayed(Duration(seconds: 1));
      _orderRepository.test(isError);
      yield InOrderState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadOrderEvent', error: _, stackTrace: stackTrace);
      yield ErrorOrderState(0, _?.toString());
    }
  }
}
