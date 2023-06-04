import 'size.dart';
import 'topping.dart';

class Food {
  String id;
  String name;
  double price;
  String description;
  List<Size>? sizes;
  List<Topping>? toppings;
  List<String> images;

  Food({
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
