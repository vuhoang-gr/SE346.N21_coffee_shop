import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

var drinkReference = firestoreInstance.collection("Food");
var toppingReference = firestoreInstance.collection("Topping");
var sizeReference = firestoreInstance.collection("Size");

var storeReference = firestoreInstance.collection("Store");

var promoReference = firestoreInstance.collection("Promo");

var userReference = firestoreInstance.collection("users");
