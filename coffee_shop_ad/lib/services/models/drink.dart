import 'size.dart';
import 'topping.dart';

class Drink {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<Size>? sizes;
  final List<Topping>? toppings;
  final List<dynamic> images;

  Drink({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
    required this.toppings,
    required this.images,
  });

  Map<String, String> toMap() {
    return {'id': id};
  }
}
