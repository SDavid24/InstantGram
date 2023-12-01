

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/backend/authenticator.dart';
import 'package:instantgram/state/auth/models/auth_result.dart';
import 'package:instantgram/state/auth/models/auth_state.dart';
import 'package:instantgram/state/posts/typedefs/user_id.dart';
import 'package:instantgram/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState>{
  final _authenticator = Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super ( const AuthState.unKnown()){
    if(_authenticator.isAlreadyLoggedIn){ //Checks if user is already logged in
      state = AuthState(
          result: AuthResult.success,
          isLoading: false,
          userId: _authenticator.userId,
      );
    }
  }

  //Notified the app that a log out process is going on
  Future<void> logout() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logout();

    print('log out successful: ${state.result}');
    state = const AuthState.unKnown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId =  _authenticator.userId;

    if (result == AuthResult.success && userId != null){ //if authentication is successful, create user
      await saveUserInfo(
        userId: userId,
      );
    }

    state = AuthState(result: result, isLoading: false, userId: userId);
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId =  _authenticator.userId;

    if (result == AuthResult.success && userId != null){ //if authentication is successful, create user
      await saveUserInfo(
        userId: userId,
      );
    }

    state = AuthState(result: result, isLoading: false, userId: userId);
  }


  //Method that authenticates and update or saves login details to firebase
  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );

}