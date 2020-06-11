import 'package:equatable/equatable.dart';
import 'package:nexttakeout_seller/menu/index.dart';

abstract class MenuState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  MenuState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  MenuState getStateCopy();

  MenuState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnMenuState extends MenuState {

  UnMenuState(int version) : super(version);

  @override
  String toString() => 'UnMenuState';

  @override
  UnMenuState getStateCopy() {
    return UnMenuState(0);
  }

  @override
  UnMenuState getNewVersion() {
    return UnMenuState(version+1);
  }
}
class MenuItemsUpdatedState extends MenuState{
   MenuItemsUpdatedState(int version) : super(version);

  @override
  String toString() => 'MenuItemsUpdatedState';

  @override
  MenuItemsUpdatedState getStateCopy() {
    return MenuItemsUpdatedState(0);
  }

  @override
  MenuItemsUpdatedState getNewVersion() {
    return MenuItemsUpdatedState(version+1);
  }
}
/// Initialized
class InMenuState extends MenuState {
  final List<MenuModel> menuItems;

  InMenuState(int version, this.menuItems) : super(version, [menuItems]);

  @override
  String toString() => 'InMenuState';

  @override
  InMenuState getStateCopy() {
    return InMenuState(version, menuItems);
  }

  @override
  InMenuState getNewVersion() {
    return InMenuState(version+1, menuItems);
  }
}

class ErrorMenuState extends MenuState {
  final String errorMessage;

  ErrorMenuState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorMenuState';

  @override
  ErrorMenuState getStateCopy() {
    return ErrorMenuState(version, errorMessage);
  }

  @override
  ErrorMenuState getNewVersion() {
    return ErrorMenuState(version+1, 
    errorMessage);
  }
}
