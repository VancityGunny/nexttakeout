import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout/place_order/index.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  // todo: check singleton for logic in project
  static final PlaceOrderBloc _placeOrderBlocSingleton = PlaceOrderBloc._internal();
  factory PlaceOrderBloc() {
    return _placeOrderBlocSingleton;
  }
  PlaceOrderBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
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
      developer.log('$_', name: 'PlaceOrderBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
