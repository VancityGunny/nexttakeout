import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/business/business_repository.dart';
import 'package:nexttakeout/menu_search/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MenuSearchEvent {
  Stream<MenuSearchState> applyAsync(
      {MenuSearchState currentState, MenuSearchBloc bloc});
  final MenuSearchRepository _menuSearchRepository = MenuSearchRepository();
}

class UnMenuSearchEvent extends MenuSearchEvent {
  @override
  Stream<MenuSearchState> applyAsync({MenuSearchState currentState, MenuSearchBloc bloc}) async* {
    yield UnMenuSearchState(0);
  }
}

class LoadMenuSearchEvent extends MenuSearchEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadMenuSearchEvent';

  LoadMenuSearchEvent(this.isError);

  @override
  Stream<MenuSearchState> applyAsync(
      {MenuSearchState currentState, MenuSearchBloc bloc}) async* {
    try {
      yield UnMenuSearchState(0);
      await Future.delayed(Duration(seconds: 1));
      _menuSearchRepository.test(isError);
      // Load restaurant with menu 
      var businessRepo = new BusinessRepository();
      var foundBusinesses = await businessRepo.getNearbyBusinesses();
      yield InMenuSearchState(0, foundBusinesses);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadMenuSearchEvent', error: _, stackTrace: stackTrace);
      yield ErrorMenuSearchState(0, _?.toString());
    }
  }
}
