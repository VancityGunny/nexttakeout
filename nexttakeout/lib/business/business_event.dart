import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/business/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BusinessEvent {
  Stream<BusinessState> applyAsync(
      {BusinessState currentState, BusinessBloc bloc});
  final BusinessRepository _businessRepository = BusinessRepository();
}

class UnBusinessEvent extends BusinessEvent {
  @override
  Stream<BusinessState> applyAsync({BusinessState currentState, BusinessBloc bloc}) async* {
    yield UnBusinessState(0);
  }
}

class LoadBusinessEvent extends BusinessEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadBusinessEvent';

  LoadBusinessEvent(this.isError);

  @override
  Stream<BusinessState> applyAsync(
      {BusinessState currentState, BusinessBloc bloc}) async* {
    try {
      yield UnBusinessState(0);
      await Future.delayed(Duration(seconds: 1));
      yield InBusinessState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBusinessEvent', error: _, stackTrace: stackTrace);
      yield ErrorBusinessState(0, _?.toString());
    }
  }
}
