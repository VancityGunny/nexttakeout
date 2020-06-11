import 'package:equatable/equatable.dart';

abstract class ScanbarcodeState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  ScanbarcodeState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  ScanbarcodeState getStateCopy();

  ScanbarcodeState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnScanbarcodeState extends ScanbarcodeState {

  UnScanbarcodeState(int version) : super(version);

  @override
  String toString() => 'UnScanbarcodeState';

  @override
  UnScanbarcodeState getStateCopy() {
    return UnScanbarcodeState(0);
  }

  @override
  UnScanbarcodeState getNewVersion() {
    return UnScanbarcodeState(version+1);
  }
}

/// Initialized
class InScanbarcodeState extends ScanbarcodeState {
  final String hello;

  InScanbarcodeState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InScanbarcodeState $hello';

  @override
  InScanbarcodeState getStateCopy() {
    return InScanbarcodeState(version, hello);
  }

  @override
  InScanbarcodeState getNewVersion() {
    return InScanbarcodeState(version+1, hello);
  }
}

class ErrorScanbarcodeState extends ScanbarcodeState {
  final String errorMessage;

  ErrorScanbarcodeState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorScanbarcodeState';

  @override
  ErrorScanbarcodeState getStateCopy() {
    return ErrorScanbarcodeState(version, errorMessage);
  }

  @override
  ErrorScanbarcodeState getNewVersion() {
    return ErrorScanbarcodeState(version+1, 
    errorMessage);
  }
}
