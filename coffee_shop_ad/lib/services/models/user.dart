import 'package:coffee_shop_admin/services/models/delivery_address.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  String name;
  String phoneNumber;
  String email;
  DateTime? dob;
  List<DeliveryAddress>? addresses;
  List<Drink>? favoriteFoods;
  List<Store>? favouriteStores;
  bool isActive;
  String avatarUrl;
  String coverUrl;

  User(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      this.dob,
      required this.isActive,
      this.addresses,
      this.favoriteFoods,
      this.favouriteStores,
      this.avatarUrl =
          r'https://camo.githubusercontent.com/137115c4e2eab897b580d1f0db934f330d84654bccb0947c5e9af4bc8a66c6b6/68747470733a2f2f662e636c6f75642e6769746875622e636f6d2f6173736574732f323639323831302f323130343036312f34643839316563302d386637362d313165332d393230322d6637333934306431306632302e706e67',
      this.coverUrl =
          r'https://img.freepik.com/free-vector/restaurant-mural-wallpaper_23-2148703851.jpg?w=740&t=st=1680897435~exp=1680898035~hmac=8f6c47b6646a831c4a642b560cf9b10f1ddf80fda5d9d997299e1b2f71fe4cb9'});

  @override
  List<Object?> get props => [id];
}
