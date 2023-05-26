import 'package:firebase_auth/firebase_auth.dart';

class AuthAPI {
  //singleton
  static final AuthAPI _authAPI = AuthAPI._internal();
  factory AuthAPI() {
    return _authAPI;
  }
  AuthAPI._internal();

  final firebaseAuth = FirebaseAuth.instance;

  emailSignUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  emailLogin(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }
}
