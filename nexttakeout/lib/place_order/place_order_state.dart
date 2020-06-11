import 'package:equatable/equatable.dart';

abstract class PlaceOrderState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  PlaceOrderState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  PlaceOrderState getStateCopy();

  PlaceOrderState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnPlaceOrderState extends PlaceOrderState {

  UnPlaceOrderState(int version) : super(version);

  @override
  String toString() => 'UnPlaceOrderState';

  @override
  UnPlaceOrderState getStateCopy() {
    return UnPlaceOrderState(0);
  }

  @override
  UnPlaceOrderState getNewVersion() {
    return UnPlaceOrderState(version+1);
  }
}

/// Initialized
class InPlaceOrderState extends PlaceOrderState {
  final String hello;

  InPlaceOrderState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InPlaceOrderState $hello';

  @override
  InPlaceOrderState getStateCopy() {
    return InPlaceOrderState(version, hello);
  }

  @override
  InPlaceOrderState getNewVersion() {
    return InPlaceOrderState(version+1, hello);
  }
}

class ErrorPlaceOrderState extends PlaceOrderState {
  final String errorMessage;

  ErrorPlaceOrderState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorPlaceOrderState';

  @override
  ErrorPlaceOrderState getStateCopy() {
    return ErrorPlaceOrderState(version, errorMessage);
  }

  @override
  ErrorPlaceOrderState getNewVersion() {
    return ErrorPlaceOrderState(version+1, 
    errorMessage);
  }
}
