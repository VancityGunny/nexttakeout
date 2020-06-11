import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  PaymentState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  PaymentState getStateCopy();

  PaymentState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnPaymentState extends PaymentState {

  UnPaymentState(int version) : super(version);

  @override
  String toString() => 'UnPaymentState';

  @override
  UnPaymentState getStateCopy() {
    return UnPaymentState(0);
  }

  @override
  UnPaymentState getNewVersion() {
    return UnPaymentState(version+1);
  }
}

/// Initialized
class InPaymentState extends PaymentState {
  final String hello;

  InPaymentState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InPaymentState $hello';

  @override
  InPaymentState getStateCopy() {
    return InPaymentState(version, hello);
  }

  @override
  InPaymentState getNewVersion() {
    return InPaymentState(version+1, hello);
  }
}

class ErrorPaymentState extends PaymentState {
  final String errorMessage;

  ErrorPaymentState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorPaymentState';

  @override
  ErrorPaymentState getStateCopy() {
    return ErrorPaymentState(version, errorMessage);
  }

  @override
  ErrorPaymentState getNewVersion() {
    return ErrorPaymentState(version+1, 
    errorMessage);
  }
}
