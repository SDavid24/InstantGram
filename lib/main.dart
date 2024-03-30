import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/backend/authenticator.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'dart:developer' as devtools show log;

import 'package:instantgram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instantgram/state/providers/is_loading_provider.dart';
import 'package:instantgram/views/components/animations/data_not_found_animation_view.dart';
import 'package:instantgram/views/components/animations/empty_contents_with_texts_animation_view.dart';
import 'package:instantgram/views/components/animations/loading_animation_view.dart';
import 'package:instantgram/views/components/loading/loadinng_screen.dart';
import 'package:instantgram/views/login/login_view.dart';
import 'package:instantgram/views/main/main_view.dart';

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
          //Take care of displaying the loading screen
          ref.listen<bool>(
            isLoadingProvider,
                (_, isLoading) {
              if (isLoading) {
                print('isloading true status is: $isLoading');
                LoadingScreen.instance().show(
                  context: context,
                );
              } else {
                print('isloading false status is: $isLoading');
                LoadingScreen.instance().hide();
              }
            },
          );
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
