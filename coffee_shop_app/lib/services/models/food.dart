import 'size.dart';
import 'topping.dart';

class Food {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<Size>? sizes;
  final List<Topping>? toppings;
  final List<String> images;
  final DateTime dateRegister;
  final bool isAvailable;
  bool isFavorite;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
    required this.toppings,
    required this.images,
    required this.dateRegister,
    required this.isAvailable,
    this.isFavorite = false
  });

  Map<String, String> toMap() {
    return {'id': id};
  }
}
