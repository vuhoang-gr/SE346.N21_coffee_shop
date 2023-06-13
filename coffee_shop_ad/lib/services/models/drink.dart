import 'size.dart';
import 'topping.dart';

class Drink {
  static List<Topping> toppings = [];
  static List<Size> sizes = [];

  final String id;
  final String name;
  final double price;
  final String description;
  final List<dynamic> images;
  final List<bool>? selectedSizes;
  final List<bool>? selectedToppings;

  Drink(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.images,
      this.selectedSizes,
      this.selectedToppings});

  Map<String, String> toMap() {
    return {'id': id};
  }
}
