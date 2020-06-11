import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout_seller/order/index.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // todo: check singleton for logic in project
  static final OrderBloc _orderBlocSingleton = OrderBloc._internal();
  factory OrderBloc() {
    return _orderBlocSingleton;
  }
  OrderBloc._internal();
  
  @override
  Future<void> close() async{
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
