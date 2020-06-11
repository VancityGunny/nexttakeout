import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout_seller/scanbarcode/index.dart';

class ScanbarcodeBloc extends Bloc<ScanbarcodeEvent, ScanbarcodeState> {
  // todo: check singleton for logic in project
  static final ScanbarcodeBloc _scanbarcodeBlocSingleton = ScanbarcodeBloc._internal();
  factory ScanbarcodeBloc() {
    return _scanbarcodeBlocSingleton;
  }
  ScanbarcodeBloc._internal();
  
  @override
  Future<void> close() async{
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
      developer.log('$_', name: 'ScanbarcodeBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
