import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout/business/index.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  // todo: check singleton for logic in project
  static final BusinessBloc _businessBlocSingleton = BusinessBloc._internal();
  factory BusinessBloc() {
    return _businessBlocSingleton;
  }
  BusinessBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  BusinessState get initialState => UnBusinessState(0);

  @override
  Stream<BusinessState> mapEventToState(
    BusinessEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'BusinessBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
