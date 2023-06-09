import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
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
  final firestore = FirebaseFirestore.instance;

  static User? currentUser;

  Future<User?> emailSignUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = await toUser(credential.user);
      if (user != null) await push(user);
      return user;
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
    // try {
    //   bool havePermission = false;
    //   final pro = await userReference.get();
    //   for (var doc in pro.docs) {
    //     var s = doc.data();
    //     var curUser = User(
    //       id: doc.id,
    //       name: s["name"] ?? "Unnamed",
    //       phoneNumber: s["phoneNumber"] ?? "",
    //       email: s["email"],
    //       isActive: s["isActive"] ?? true,
    //       avatarUrl: s["avatarUrl"] ?? "https://img.freepik.com/free-icon/user_318-159711.jpg",
    //       isAdmin: s["isAdmin"] ?? false,
    //       isStaff: s["isStaff"] ?? false,
    //       isSuperAdmin: s["isSuperAdmin"] ?? false,
    //     );
    //     if (curUser.isSuperAdmin || curUser.isAdmin) {
    //       havePermission = true;
    //       break;
    //     }
    //   }
    //   if (!havePermission) return null;
    // } catch (e) {
    //   print('Something error on check user permission.');
    // }
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print('Login Success');
      var user = await toUser(credential.user);
      return user;
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
    await GoogleSignIn().disconnect().catchError((onError) {
      print(onError);
      print('don\'t need to sign out');
      return null;
    });

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var rawUser = await firebaseAuth.signInWithCredential(credential);

      var user = await toUser(rawUser.user);
      if (user != null && user.phoneNumber == "No Phone Number") {
        await push(user);
      }
      return user;
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
          firebase_auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      var rawUser = await firebaseAuth.signInWithCredential(facebookAuthCredential);
      var user = await toUser(rawUser.user);
      if (user != null && user.phoneNumber == "No Phone Number") {
        await push(user);
      }
      return user;
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

  signOut() async {
    await firebaseAuth.signOut();
    currentUser = null;
  }

  toFireStore(User user) {
    final data = <String, dynamic>{
      "name": user.name,
      "isActive": user.isActive,
      "email": user.email,
      "dob": user.dob,
      "avatarUrl": user.avatarUrl,
      "coverUrl": user.coverUrl,
    };
    return data;
  }

  User? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return User(
      email: data['email'],
      id: id,
      name: data['name'],
      phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
      dob: DateTime.tryParse((data['dob'] ?? Timestamp.now()).toDate().toString()) ?? DateTime(0),
      isActive: data['isActive'],
      avatarUrl: data['avatarUrl'],
      coverUrl: data['coverUrl'],
    );
  }

  push(User user) async {
    try {
      final data = toFireStore(user);
      await firestore.collection("users").doc(user.id).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> get(String id) async {
    var raw = await firestore.collection('users').doc(id).get();
    var data = raw.data();
    return fromFireStore(data, id);
  }

  pop(User user) async {
    user.isActive = false;
    await update(user);
  }

  update(User user) async {
    await firestore.collection('users').doc(user.id).update(toFireStore(user));
  }

  Future<User?> toUser(firebase_auth.User? raw) async {
    if (raw == null) return null;
    User? user = await get(raw.uid);
    user ??= User(
      email: raw.email!,
      id: raw.uid,
      isActive: true,
      name: raw.displayName ?? 'No Name',
      phoneNumber: 'No Phone Number',
    );
    return user;
  }
}
