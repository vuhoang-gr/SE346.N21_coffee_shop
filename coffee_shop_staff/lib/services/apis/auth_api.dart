import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_staff/services/models/user.dart';
import 'package:coffee_shop_staff/temp/mockData.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class AuthAPI {
  //singleton
  static final AuthAPI _authAPI = AuthAPI._internal();
  factory AuthAPI() {
    return _authAPI;
  }
  AuthAPI._internal();

  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  static User? get currentUser => userSubscription.value;
  static set currentUser(User? value) {
    userSubscription = ValueNotifier(value);
  }

  static ValueNotifier<User?> userSubscription = ValueNotifier<User?>(null);

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
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
      "phoneNumber": user.phoneNumber
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
      // store: data['store'],
      store: FakeData.storeMock,

      dob: DateTime.tryParse(
              (data['dob'] ?? Timestamp.now()).toDate().toString()) ??
          DateTime.now(),
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
    currentUser = user;
  }

  Future<User?> toUser(firebase_auth.User? raw) async {
    if (raw == null) return null;
    User? user = await get(raw.uid);
    return user;
  }
}