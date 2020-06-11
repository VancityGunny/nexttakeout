import 'package:equatable/equatable.dart';
import 'package:nexttakeout/business/business_model.dart';

abstract class MenuSearchState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  MenuSearchState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  MenuSearchState getStateCopy();

  MenuSearchState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnMenuSearchState extends MenuSearchState {

  UnMenuSearchState(int version) : super(version);

  @override
  String toString() => 'UnMenuSearchState';

  @override
  UnMenuSearchState getStateCopy() {
    return UnMenuSearchState(0);
  }

  @override
  UnMenuSearchState getNewVersion() {
    return UnMenuSearchState(version+1);
  }
}

/// Initialized
class InMenuSearchState extends MenuSearchState {
  final List<BusinessModel> businesses;

  InMenuSearchState(int version, this.businesses) : super(version, [businesses]);

  @override
  String toString() => 'InMenuSearchState';

  @override
  InMenuSearchState getStateCopy() {
    return InMenuSearchState(version, businesses);
  }

  @override
  InMenuSearchState getNewVersion() {
    return InMenuSearchState(version+1, businesses);
  }
}

class ErrorMenuSearchState extends MenuSearchState {
  final String errorMessage;

  ErrorMenuSearchState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorMenuSearchState';

  @override
  ErrorMenuSearchState getStateCopy() {
    return ErrorMenuSearchState(version, errorMessage);
  }

  @override
  ErrorMenuSearchState getNewVersion() {
    return ErrorMenuSearchState(version+1, 
    errorMessage);
  }
}
