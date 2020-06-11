import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout/menu_search/index.dart';

class MenuSearchBloc extends Bloc<MenuSearchEvent, MenuSearchState> {
  // todo: check singleton for logic in project
  static final MenuSearchBloc _menuSearchBlocSingleton = MenuSearchBloc._internal();


  factory MenuSearchBloc() {
    return _menuSearchBlocSingleton;
  }
  MenuSearchBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  MenuSearchState get initialState => UnMenuSearchState(0);

  @override
  Stream<MenuSearchState> mapEventToState(
    MenuSearchEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'MenuSearchBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
