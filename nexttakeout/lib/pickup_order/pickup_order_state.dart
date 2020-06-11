import 'package:equatable/equatable.dart';

abstract class PickupOrderState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  PickupOrderState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  PickupOrderState getStateCopy();

  PickupOrderState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnPickupOrderState extends PickupOrderState {

  UnPickupOrderState(int version) : super(version);

  @override
  String toString() => 'UnPickupOrderState';

  @override
  UnPickupOrderState getStateCopy() {
    return UnPickupOrderState(0);
  }

  @override
  UnPickupOrderState getNewVersion() {
    return UnPickupOrderState(version+1);
  }
}

/// Initialized
class InPickupOrderState extends PickupOrderState {
  final String hello;

  InPickupOrderState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InPickupOrderState $hello';

  @override
  InPickupOrderState getStateCopy() {
    return InPickupOrderState(version, hello);
  }

  @override
  InPickupOrderState getNewVersion() {
    return InPickupOrderState(version+1, hello);
  }
}

class ErrorPickupOrderState extends PickupOrderState {
  final String errorMessage;

  ErrorPickupOrderState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorPickupOrderState';

  @override
  ErrorPickupOrderState getStateCopy() {
    return ErrorPickupOrderState(version, errorMessage);
  }

  @override
  ErrorPickupOrderState getNewVersion() {
    return ErrorPickupOrderState(version+1, 
    errorMessage);
  }
}
