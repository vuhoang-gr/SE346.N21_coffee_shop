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

  // Future<bool> push() async {
  //   try {
  //     foodReference.add({
  //       "createAt": DateTime.now(),
  //       "description":
  //           "Với phiên bản chai fresh 500ml, thức uống \"best seller\" đỉnh cao mang một diện mạo tươi mới, tiện lợi, phù hợp với bình thường mới và vẫn giữ nguyên vị thanh ngọt của đào, vị chua dịu của cam vàng nguyên vỏ và vị trà đen thơm lừng ly Trà đào cam sả nguyên bản. *Sản phẩm dùng ngon nhất trong ngày. *Sản phẩm mặc định mức đường và không đá.",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/products%2Ffood%2FTr%C3%A0%20%C4%90%C3%A0o%20Cam%20S%E1%BA%A3%20Chai%20Fresh%20500ML.png?alt=media&token=ef7623f9-fa6a-4c7f-88c7-f4af41f1dc85",
  //         "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/products%2Ffood%2FTr%C3%A0%20%C4%90%C3%A0o%20Cam%20S%E1%BA%A3%20Chai%20Fresh%20500ML%202.png?alt=media&token=9bf2996a-87f3-4c8e-9de9-583c2683707d",
  //         "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/products%2Ffood%2FTr%C3%A0%20%C4%90%C3%A0o%20Cam%20S%E1%BA%A3%20Chai%20Fresh%20500ML%203.png?alt=media&token=84c69e91-54dc-423f-ac80-afb0f2ef3f50",
  //         "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/products%2Ffood%2FTr%C3%A0%20%C4%90%C3%A0o%20Cam%20S%E1%BA%A3%20Chai%20Fresh%20500ML%204.png?alt=media&token=e8e005ef-5fd6-4a03-96d5-60385b1f7c0b"
  //       ],
  //       "price": 105000,
  //       "name": "Trà Đào Cam Sả Chai Fresh 500ML",
  //       "sizes": [
  //         //"IScifm2SkSZIkgQQw47b", //L
  //         "qjdBIUz6QyLHJZhb9nsz", //S
  //         //"jbtpzFWjGp2qRARb3eqm"  //M
  //       ],
  //       "toppings": [
  //         //"5jRObE0my6e6Dha6vWhd",
  //         "vg8OXLVcpHTQN2YCOBXe",
  //         "Eyy2FJnm3MLCprZs7K2H"
  //         //"cpvZ1lyo40KSFZ2Plrhx",
  //         //"UkeSEcYAQ65MTd55e5LN"
  //       ]
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

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
