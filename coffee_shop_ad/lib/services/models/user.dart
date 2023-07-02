import 'package:coffee_shop_admin/services/models/address.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  String name;
  String phoneNumber;
  String email;
  DateTime? dob;
  List<Address>? addresses;
  List<Drink>? favoriteFoods;
  List<Store>? favoriteStores;
  bool isActive;
  bool isAdmin;
  bool isStaff;
  String avatarUrl;
  String coverUrl;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.dob,
    required this.isActive,
    this.addresses,
    this.favoriteFoods,
    this.favoriteStores,
    this.avatarUrl = r'https://img.freepik.com/free-icon/user_318-159711.jpg',
    this.coverUrl =
        r'https://img.freepik.com/free-vector/restaurant-mural-wallpaper_23-2148703851.jpg?w=740&t=st=1680897435~exp=1680898035~hmac=8f6c47b6646a831c4a642b560cf9b10f1ddf80fda5d9d997299e1b2f71fe4cb9',
    this.isAdmin = false,
    this.isStaff = false,
  });

  @override
  List<Object?> get props => [id];
}
