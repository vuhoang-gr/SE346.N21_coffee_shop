import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/food.dart';
import 'package:coffee_shop_app/services/models/store.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  String name;
  String phoneNumber;
  String email;
  DateTime? dob;
  List<DeliveryAddress>? addresses;
  List<Food>? favoriteFoods;
  List<Store>? favouriteStores;
  bool isActive;
  bool isAdmin;
  bool isStaff;
  String avatarUrl;
  String coverUrl;
  DateTime createDate;

  User(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      this.dob,
      required this.createDate,
      required this.isActive,
      this.isAdmin = false,
      this.isStaff = false,
      this.addresses,
      this.favoriteFoods,
      this.favouriteStores,
      this.avatarUrl =
          'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg',
      this.coverUrl =
          r'https://img.freepik.com/free-vector/restaurant-mural-wallpaper_23-2148703851.jpg?w=740&t=st=1680897435~exp=1680898035~hmac=8f6c47b6646a831c4a642b560cf9b10f1ddf80fda5d9d997299e1b2f71fe4cb9'});

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        dob,
        isActive,
        addresses,
        favoriteFoods,
        favouriteStores,
        avatarUrl,
        coverUrl
      ];
}
