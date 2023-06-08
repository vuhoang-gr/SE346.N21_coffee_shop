import 'package:cloud_firestore/cloud_firestore.dart';
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
      if (AuthAPI.currentUser != null) {
        DocumentSnapshot userData =
            await userReference.doc(AuthAPI.currentUser!.id).get();
        if (userData.exists) {
          favoriteFoods =
              (userData.data() as Map<String, dynamic>)['favoriteFoods'] ?? [];
        }
      }

      List<Food> foods = [];
      for (var doc in snapshot.docs) {
        bool isAvailable = (stateFood[doc.id] == null ||
            stateFood[doc.id]!.isNotEmpty);
        Food? food = await fromFireStore(
            doc.data() as Map<String, dynamic>, doc.id, isAvailable);
        if (food != null) {
          bool isFavorite = favoriteFoods.any((element) => element == doc.id);
          food.isFavorite = isFavorite;
          foods.add(food);
        }
      }

      currentFoods = foods;
      return foods;
    });
  }

  Future<bool> updateFavorite(String productId) async {
    try {
      final userDoc = await userReference.doc(AuthAPI.currentUser!.id).get();
      final favorites =
          (userDoc.data() as Map<String, dynamic>)['favoriteFoods'] ?? [];
      if (favorites.contains(productId)) {
        favorites.remove(productId);
      } else {
        favorites.add(productId);
      }
      await userReference
          .doc(AuthAPI.currentUser!.id)
          .update({'favoriteFoods': favorites});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Food?> fromFireStore(
      Map<String, dynamic>? data, String id, bool isAvailable) async {
    if (data == null) return null;

    return Food(
      id: id,
      name: data["name"],
      price: data["price"].toDouble(),
      description: data["description"],
      sizes: data['sizes']?.cast<String>() ?? [],
      toppings: data['toppings']?.cast<String>() ?? [],
      images: data["images"].cast<String>(),
      dateRegister: data["createAt"].toDate(),
      isAvailable: isAvailable,
    );
  }
}
