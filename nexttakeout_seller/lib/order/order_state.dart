import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  OrderState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  OrderState getStateCopy();

  OrderState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnOrderState extends OrderState {

  UnOrderState(int version) : super(version);

  @override
  String toString() => 'UnOrderState';

  @override
  UnOrderState getStateCopy() {
    return UnOrderState(0);
  }

  @override
  UnOrderState getNewVersion() {
    return UnOrderState(version+1);
  }
}

/// Initialized
class InOrderState extends OrderState {
  final String hello;

  InOrderState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InOrderState $hello';

  @override
  InOrderState getStateCopy() {
    return InOrderState(version, hello);
  }

  @override
  InOrderState getNewVersion() {
    return InOrderState(version+1, hello);
  }
}

class ErrorOrderState extends OrderState {
  final String errorMessage;

  ErrorOrderState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorOrderState';

  @override
  ErrorOrderState getStateCopy() {
    return ErrorOrderState(version, errorMessage);
  }

  @override
  ErrorOrderState getNewVersion() {
    return ErrorOrderState(version+1, 
    errorMessage);
  }
}
