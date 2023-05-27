import 'package:coffee_shop_app/services/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthAPI {
  //singleton
  static final AuthAPI _authAPI = AuthAPI._internal();
  factory AuthAPI() {
    return _authAPI;
  }
  AuthAPI._internal();

  final firebaseAuth = firebase_auth.FirebaseAuth.instance;

  static User? currentUser;

  Future<User?> emailSignUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return toUser(credential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> emailLogin(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Login Success');
      return toUser(credential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<User?> googleLogin() async {
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().disconnect();
    }
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var rawUser = await firebaseAuth.signInWithCredential(credential);
      return toUser(rawUser.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<User?> facebookLogin() async {
    await FacebookAuth.instance.logOut();
    await FacebookAuth.i.logOut();
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final firebase_auth.OAuthCredential facebookAuthCredential =
          firebase_auth.FacebookAuthProvider.credential(
              loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      var rawUser =
          await firebaseAuth.signInWithCredential(facebookAuthCredential);
      return toUser(rawUser.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'account-exists-with-different-credential') {
        print('account-exists-with-different-credential');
      }
    }
    return null;
  }

  User? toUser(firebase_auth.User? raw) {
    if (raw == null) return null;
    var user = User(
        id: raw.uid,
        name: raw.displayName != null ? raw.displayName! : 'No Name',
        phoneNumber:
            raw.phoneNumber != null ? raw.phoneNumber! : 'No phone number',
        email: raw.email!,
        isActive: true);
    if (raw.photoURL != null) {
      user.avatarUrl = raw.photoURL!;
    }
    return user;
  }

  signOut() async {
    await firebaseAuth.signOut();
    currentUser = null;
  }
}
