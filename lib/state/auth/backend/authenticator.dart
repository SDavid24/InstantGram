import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../posts/typedefs/user_id.dart';
import '../constants/constants.dart';
import '../models/auth_result.dart';

class Authenticator{

  User? get currentUser => FirebaseAuth.instance.currentUser;
  UserId? get userId => currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => currentUser?.displayName ?? '' ;
  String? get email => currentUser?.email;


  Future<void> logout() async{ //We are going to sign out from 3 different services
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final accessToken = loginResult.accessToken?.token;   //in order to know if user cancelled the login process, we need to know the login result

    if(accessToken == null){
      //User has aborted the logging in process
      return AuthResult.aborted;
    }
    //get credentials
    final oauthCredentials = FacebookAuthProvider.credential(accessToken);

    try{ //Sign In
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials,);
      return AuthResult.success;
    } on FirebaseAuthException catch (e){ //most likely the user has signed in with another provider which inn this case is Google. And it wants to sign in with the same credentials using Facebook. Firebase won't allow that of course

      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredential &&
          email != null && credential != null) {
        final providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email); //get all sign in methods that user had recently used

        if(providers.contains(Constants.googleCom)){ //check if user had previously logged in with google
          await loginWithGoogle(); //login with it
          currentUser?.linkWithCredential(credential); //This tells firebase to link your credentials with Facebbok cos you are the same person
        }
        return AuthResult.success;
      }
      return AuthResult.failure;

    }
  }

  Future<AuthResult> loginWithGoogle() async{
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      Constants.emailScope,
    ]);

    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null){  //If no email was chosen
      return AuthResult.aborted;
    }

    //get credentials
    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try{ //Sign in
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;

    }catch (e){
      return AuthResult.failure;
    }
  }



}