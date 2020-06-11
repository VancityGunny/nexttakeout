import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout_seller/menu/index.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  // todo: check singleton for logic in project
  static final MenuBloc _menuBlocSingleton = MenuBloc._internal();
  factory MenuBloc() {
    return _menuBlocSingleton;
  }
  MenuBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  MenuState get initialState => UnMenuState(0);

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'MenuBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
