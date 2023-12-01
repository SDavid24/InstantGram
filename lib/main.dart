import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/backend/authenticator.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'dart:developer' as devtools show log;

import 'package:instantgram/state/auth/providers/is_logged_in_provider.dart';

extension Log on Object{
  void log() => devtools.log(toString());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey

      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          isLoggedIn.log();
          if(isLoggedIn){
            return const MainView();
          }else{
            return const LoginView();
          }
        },
      ),
    );
  }
}

//For when you are already logged in
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main view'),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ElevatedButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
            },
            child: const Text('Log out'),

          );
        },

      ),
    );
  }
}

//For when you are not logged in
class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login view'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: ref.read(authStateProvider.notifier).loginWithGoogle, //connecting to the general login process so that it result can be easily read by other functions
              child: const Text('Sign in with Google'),
          ),
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
            child: const Text('Sign in with Facebook',),
          ),

        ],
      ),
    );
  }
}


