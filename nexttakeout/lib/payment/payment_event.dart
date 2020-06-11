import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/payment/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PaymentEvent {
  Stream<PaymentState> applyAsync(
      {PaymentState currentState, PaymentBloc bloc});
  final PaymentRepository _paymentRepository = PaymentRepository();
}

class UnPaymentEvent extends PaymentEvent {
  @override
  Stream<PaymentState> applyAsync({PaymentState currentState, PaymentBloc bloc}) async* {
    yield UnPaymentState(0);
  }
}

class LoadPaymentEvent extends PaymentEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadPaymentEvent';

  LoadPaymentEvent(this.isError);

  @override
  Stream<PaymentState> applyAsync(
      {PaymentState currentState, PaymentBloc bloc}) async* {
    try {
      yield UnPaymentState(0);
      await Future.delayed(Duration(seconds: 1));
      _paymentRepository.test(isError);
      yield InPaymentState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadPaymentEvent', error: _, stackTrace: stackTrace);
      yield ErrorPaymentState(0, _?.toString());
    }
  }
}
