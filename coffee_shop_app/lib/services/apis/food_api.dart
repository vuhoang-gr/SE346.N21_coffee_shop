import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food.dart';
import 'auth_api.dart';

class FoodAPI {
  //singleton
  static final FoodAPI _foodAPI = FoodAPI._internal();
  factory FoodAPI() {
    return _foodAPI;
  }
  FoodAPI._internal();

  List<Food> currentFoods = [];

  final firestore = FirebaseFirestore.instance;
  final CollectionReference foodReference =
      FirebaseFirestore.instance.collection('Food');
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Food>> fetchData(Map<String, List<String>>? stateFood) {
    return foodReference.snapshots().asyncMap<List<Food>>((snapshot) async {
      if (stateFood == null) {
        return [];
      }

      List<dynamic> favoriteFoods = [];
      if (FirebaseAuth.instance.currentUser != null) {
        DocumentSnapshot userData = await userReference
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (userData.exists) {
          favoriteFoods =
              (userData.data() as Map<String, dynamic>)['favoriteFoods'] ?? [];
        }
      }

      List<Food> foods = [];
      for (var doc in snapshot.docs) {
        bool isAvailable =
            (stateFood[doc.id] == null || stateFood[doc.id]!.isNotEmpty);
        Food? food = await fromFireStore(
            doc.data() as Map<String, dynamic>, doc.id, isAvailable);
        if (food != null) {
          bool isFavorite = favoriteFoods.any((element) => element == doc.id);
          food.isFavorite = isFavorite;
          foods.add(food);
        }
      }

      foods.sort((a, b) => a.name.compareTo(b.name));

      currentFoods = foods;
      return foods;
    });
  }

  Future<bool?> updateFavorite(String productId, bool isFavorite) async {
    try {
      final userDoc = await userReference.doc(AuthAPI.currentUser!.id).get();
      final favorites =
          (userDoc.data() as Map<String, dynamic>)['favoriteFoods'] ?? [];
      if (favorites.contains(productId)) {
        if (!isFavorite) {
          favorites.remove(productId);
        } else {
          return false;
        }
      } else {
        if (isFavorite) {
          favorites.add(productId);
        } else {
          return false;
        }
      }
      await userReference
          .doc(AuthAPI.currentUser!.id)
          .update({'favoriteFoods': favorites});
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<Food?> fromFireStore(
      Map<String, dynamic>? data, String id, bool isAvailable) async {
    if (data == null) return null;

    List<String> sizes = data['sizes']?.cast<String>() ?? [];
    return Food(
      id: id,
      name: data["name"],
      price: data["price"].toDouble(),
      description: data["description"],
      sizes: sizes,
      toppings: data['toppings']?.cast<String>() ?? [],
      images: data["images"].cast<String>(),
      dateRegister: data["createAt"].toDate(),
      isAvailable: isAvailable && sizes.isNotEmpty,
    );
  }
}
