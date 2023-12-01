import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/models/auth_result.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';

//Using another provider to monitor a provider. In this case 'ref' is imoortant
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result ==  AuthResult.success;
});