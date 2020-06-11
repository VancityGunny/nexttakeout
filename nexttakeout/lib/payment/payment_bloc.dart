import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout/payment/index.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  // todo: check singleton for logic in project
  static final PaymentBloc _paymentBlocSingleton = PaymentBloc._internal();
  factory PaymentBloc() {
    return _paymentBlocSingleton;
  }
  PaymentBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  PaymentState get initialState => UnPaymentState(0);

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'PaymentBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
