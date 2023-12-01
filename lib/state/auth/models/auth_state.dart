import 'package:flutter/foundation.dart' show immutable;

import '../../posts/typedefs/user_id.dart';
import 'auth_result.dart';

@immutable
class AuthState{
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  //Sets the 3 properties accordingly to an unknown state
  const AuthState.unKnown()
      : result = null,
        isLoading = false,
        userId = null;

  //Recreates an identical AuthState with a different isLoading status
  AuthState copiedWithIsLoading (bool isLoading) => AuthState(
    result: result,
    isLoading: isLoading,
    userId: userId
  );

  @override
  bool operator == (covariant AuthState other) =>
      identical(this, other) || //they are equal if they are identucal
          (result == other.result &&
              isLoading == other.isLoading &&
              userId == other.userId);

  @override
  int get hashCode => Object.hash(
      result,
      isLoading,
      userId
  );





}