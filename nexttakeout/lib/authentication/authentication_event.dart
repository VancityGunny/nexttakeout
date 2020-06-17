import 'dart:async';
import 'dart:developer' as developer;

import 'package:nexttakeout/authentication/index.dart';
import 'package:meta/meta.dart';
import 'package:nexttakeout/business/business_model.dart';
import 'package:nexttakeout/common/global_object.dart' as globals;

@immutable
abstract class AuthEvent {
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc});
  final AuthRepository _authRepository = AuthRepository();
}

class RegisterNewBusinessAuthEvent extends AuthEvent {
  @override
  String toString() => 'RegisterNewBusinessAuthEvent';
  final BusinessModel newBusiness;
  RegisterNewBusinessAuthEvent(this.newBusiness);

  @override
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async* {
    try {
      //TODO: add new business
      yield AuthenticatedAuthState(newBusiness.businessName);
    } catch (_) {
      //TODO: catch failed login
      //yield LogInFailureState();
    }
  }
}

class LogOutEvent extends AuthEvent {
  @override
  String toString() => 'LogOutEvent';
  LogOutEvent();

  @override
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async* {
    try {
      
    _authRepository.signOut();
      yield InAuthState();
    } catch (_) {
      //TODO: catch failed login
      //yield LogInFailureState();
    }
  }
}

class LoginInWithGoogleAuthEvent extends AuthEvent {
  @override
  String toString() => 'LoginInWithGoogleAuthEvent';

  LoginInWithGoogleAuthEvent();

  @override
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async* {
    try {
      var firebaseUser = await _authRepository.signInWithGoogle();
      var foundUser = await _authRepository.getUserByUid(firebaseUser.uid);
      // if not found user in database then it's new user
      if (foundUser == null) {
        await _authRepository.addUserFromFirebaseUser(firebaseUser);
      }
      yield AuthenticatedAuthState(firebaseUser.displayName);
    } catch (_) {
      //TODO: catch failed login
      //yield LogInFailureState();
    }
  }
}

class UnAuthEvent extends AuthEvent {
  @override
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async* {
    yield UnAuthState();
  }
}

class LoadAuthEvent extends AuthEvent {
  final bool isError;
  @override
  String toString() => 'LoadAuthEvent';

  LoadAuthEvent(this.isError);

  @override
  Stream<AuthState> applyAsync({AuthState currentState, AuthBloc bloc}) async* {
    try {
      // check if already signed in
      final isSignedIn = await _authRepository.isSignedIn();

      if (isSignedIn) {
        final firebaseUser = await _authRepository.getCurrentUser();
        final user = await _authRepository.getUserByUid(firebaseUser.uid);
        if (user != null) {
          globals.currentUserId = user.id;
          globals.currentUserDisplayName = user.displayName;
          yield AuthenticatedAuthState(user.displayName);
        } else {
          yield InAuthState();
        }
        // if not found user then create it
      } else {
        yield InAuthState();
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadAuthEvent', error: _, stackTrace: stackTrace);
      yield ErrorAuthState(_?.toString());
    }
  }
}
