import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout_seller/scanbarcode/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScanbarcodeEvent {
  Stream<ScanbarcodeState> applyAsync(
      {ScanbarcodeState currentState, ScanbarcodeBloc bloc});
  final ScanbarcodeRepository _scanbarcodeRepository = ScanbarcodeRepository();
}

class UnScanbarcodeEvent extends ScanbarcodeEvent {
  @override
  Stream<ScanbarcodeState> applyAsync({ScanbarcodeState currentState, ScanbarcodeBloc bloc}) async* {
    yield UnScanbarcodeState(0);
  }
}

class LoadScanbarcodeEvent extends ScanbarcodeEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadScanbarcodeEvent';

  LoadScanbarcodeEvent(this.isError);

  @override
  Stream<ScanbarcodeState> applyAsync(
      {ScanbarcodeState currentState, ScanbarcodeBloc bloc}) async* {
    try {
      yield UnScanbarcodeState(0);
      await Future.delayed(Duration(seconds: 1));
      _scanbarcodeRepository.test(isError);
      yield InScanbarcodeState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScanbarcodeEvent', error: _, stackTrace: stackTrace);
      yield ErrorScanbarcodeState(0, _?.toString());
    }
  }
}
