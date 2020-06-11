import 'package:equatable/equatable.dart';

abstract class BusinessState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  BusinessState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  BusinessState getStateCopy();

  BusinessState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnBusinessState extends BusinessState {

  UnBusinessState(int version) : super(version);

  @override
  String toString() => 'UnBusinessState';

  @override
  UnBusinessState getStateCopy() {
    return UnBusinessState(0);
  }

  @override
  UnBusinessState getNewVersion() {
    return UnBusinessState(version+1);
  }
}

/// Initialized
class InBusinessState extends BusinessState {
  final String hello;

  InBusinessState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InBusinessState $hello';

  @override
  InBusinessState getStateCopy() {
    return InBusinessState(version, hello);
  }

  @override
  InBusinessState getNewVersion() {
    return InBusinessState(version+1, hello);
  }
}

class ErrorBusinessState extends BusinessState {
  final String errorMessage;

  ErrorBusinessState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorBusinessState';

  @override
  ErrorBusinessState getStateCopy() {
    return ErrorBusinessState(version, errorMessage);
  }

  @override
  ErrorBusinessState getNewVersion() {
    return ErrorBusinessState(version+1, 
    errorMessage);
  }
}
