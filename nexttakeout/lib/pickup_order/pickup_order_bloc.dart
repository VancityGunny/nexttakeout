import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout/pickup_order/index.dart';

class PickupOrderBloc extends Bloc<PickupOrderEvent, PickupOrderState> {
  // todo: check singleton for logic in project
  static final PickupOrderBloc _pickupOrderBlocSingleton = PickupOrderBloc._internal();
  factory PickupOrderBloc() {
    return _pickupOrderBlocSingleton;
  }
  PickupOrderBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
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
      developer.log('$_', name: 'PickupOrderBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
