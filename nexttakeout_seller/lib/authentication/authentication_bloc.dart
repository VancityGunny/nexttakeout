import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:nexttakeout_seller/authentication/index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  Future<void> close() async {
    // dispose objects
    await super.close();
  }

  @override
  AuthState get initialState => UnAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'AuthBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
