import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
var drinkReference = firestore.collection("Food");
var toppingReference = firestore.collection("Topping");
var sizeReference = firestore.collection("Size");

var storeReference = firestore.collection("Store");

var promoReference = firestore.collection("PromoTest");

var userReference = firestore.collection("users");
