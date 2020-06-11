import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  /// notify change state without deep clone state

  final List propss;
  AuthState([this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  AuthState getStateCopy();

  AuthState getNewVersion();

  @override
  List<Object> get props => ([...propss ?? []]);
}

/// Authenticated
class AuthenticatedAuthState extends AuthState {
  final String displayName;

  AuthenticatedAuthState(this.displayName) : super([displayName]);

  @override
  String toString() => 'Authenticated $displayName';

  @override
  AuthenticatedAuthState getStateCopy() {
    return AuthenticatedAuthState(displayName);
  }

  @override
  AuthenticatedAuthState getNewVersion() {
    return AuthenticatedAuthState(displayName);
  }
}

/// UnInitialized
class UnAuthState extends AuthState {
  UnAuthState() : super();

  @override
  String toString() => 'UnAuthState';

  @override
  UnAuthState getStateCopy() {
    return UnAuthState();
  }

  @override
  UnAuthState getNewVersion() {
    return UnAuthState();
  }
}

/// Initialized
class InAuthState extends AuthState {
  InAuthState() : super();

  @override
  String toString() => 'InAuthState';

  @override
  InAuthState getStateCopy() {
    return InAuthState();
  }

  @override
  InAuthState getNewVersion() {
    return InAuthState();
  }
}

class ErrorAuthState extends AuthState {
  final String errorMessage;

  ErrorAuthState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorAuthState';

  @override
  ErrorAuthState getStateCopy() {
    return ErrorAuthState(errorMessage);
  }

  @override
  ErrorAuthState getNewVersion() {
    return ErrorAuthState(errorMessage);
  }
}
