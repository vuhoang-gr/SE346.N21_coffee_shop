import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/apis/size_api.dart';
import 'package:coffee_shop_app/services/apis/topping_api.dart';
import 'package:coffee_shop_app/services/models/topping.dart';
import '../models/food.dart';
import '../models/size.dart';
import 'auth_api.dart';

class FoodAPI {
  //singleton
  static final FoodAPI _foodAPI = FoodAPI._internal();
  factory FoodAPI() {
    return _foodAPI;
  }
  FoodAPI._internal();

  static List<Food>? currentFoods;

  final firestore = FirebaseFirestore.instance;
  final CollectionReference foodReference =
      FirebaseFirestore.instance.collection('Food');
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future<List<Food>> fetchData(
      {Map<String, List<String>>? stateFood,
      List<String>? stateTopping}) async {
    QuerySnapshot foodSnapshot = await foodReference.get(
        GetOptions(serverTimestampBehavior: ServerTimestampBehavior.previous));

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
    for (QueryDocumentSnapshot doc in foodSnapshot.docs) {
      bool isFavorite = favoriteFoods.any((element) => element == doc.id);
      foods.add(await toObject(
          doc.data() as Map<String, dynamic>,
          doc.id,
          isFavorite,
          stateTopping ?? [],
          stateFood == null ? [] : stateFood[doc.id]));
    }
    return foods;
  }

  Future<Food> toObject(Map<String, dynamic> data, String id, bool isFavorite,
      List<String> bannedTopping, List<String>? bannedSize) async {
    bool isAvailable = bannedSize == null || bannedSize.isNotEmpty;

    List<Size> sizes = [];
    List<Topping> toppings = [];

    if (isAvailable) {
      if (bannedSize != null) {
        List<dynamic> sizesRef = data['sizes'];

        for (int i = 0; i < sizesRef.length; i++) {
          var sizeSnapshot = await sizesRef[i].get();
          if (!bannedSize.contains(sizeSnapshot.id)) {
            Size? size = SizeApi().fromFireStore(
                sizeSnapshot.data() as Map<String, dynamic>, sizeSnapshot.id);
            if (size != null) {
              sizes.add(size);
            }
          }
        }
      }

      List<dynamic> toppingsRef = data['toppings'];

      for (int i = 0; i < toppingsRef.length; i++) {
        var toppingSnapshot = await toppingsRef[i].get();
        if (!bannedTopping.contains(toppingSnapshot.id)) {
          Topping? topping = ToppingApi().fromFireStore(
              toppingSnapshot.data() as Map<String, dynamic>,
              toppingSnapshot.id);
          if (topping != null) {
            toppings.add(topping);
          }
        }
      }
    }
    return Food(
        id: id,
        name: data["name"],
        price: data["price"].toDouble(),
        description: data["description"],
        sizes: sizes,
        toppings: toppings,
        images: data["images"].cast<String>(),
        dateRegister: data["createAt"].toDate(),
        isAvailable: isAvailable,
        isFavorite: isFavorite);
  }
}
