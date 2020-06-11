import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout_seller/menu/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MenuEvent {
  Stream<MenuState> applyAsync({MenuState currentState, MenuBloc bloc});
  final MenuRepository _menuRepository = MenuRepository();
}

class UnMenuEvent extends MenuEvent {
  @override
  Stream<MenuState> applyAsync({MenuState currentState, MenuBloc bloc}) async* {
    yield UnMenuState(0);
  }
}

class UpdateMenuItemsEvent extends MenuEvent {
  final List<MenuModel> updatedMenuItems;
  UpdateMenuItemsEvent(this.updatedMenuItems);
  @override
  Stream<MenuState> applyAsync({MenuState currentState, MenuBloc bloc}) async* {
    // update menu item
    _menuRepository.updateMenuItems(updatedMenuItems);
    yield InMenuState(0, updatedMenuItems);
    //yield MenuItemsUpdatedState(0);
  }
}

class LoadMenuEvent extends MenuEvent {
  final bool isError;
  @override
  String toString() => 'LoadMenuEvent';

  LoadMenuEvent(this.isError);

  @override
  Stream<MenuState> applyAsync({MenuState currentState, MenuBloc bloc}) async* {
    try {
      yield UnMenuState(0);
      await Future.delayed(Duration(seconds: 1));
      _menuRepository.test(isError);
      // load menu items for this restaurant
      List<MenuModel> menuItems = await _menuRepository.fetchMenuItems();
      yield InMenuState(0, menuItems);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadMenuEvent', error: _, stackTrace: stackTrace);
      yield ErrorMenuState(0, _?.toString());
    }
  }
}
