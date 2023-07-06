import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFood {
  // unit price including price of one drink, size price, topping price
  // size is the size id
  String? id;
  String idFood;
  String image;
  String name;
  int quantity;
  String size;
  String? topping;
  String? note;
  double unitPrice;
  OrderFood(
      {required this.name,
      this.id,
      required this.quantity,
      required this.size,
      required this.image,
      this.topping,
      this.note,
      required this.unitPrice,
      required this.idFood});

  OrderFood.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : id = json.id,
        idFood = json.data()!.containsKey('idFood') ? json['idFood'] : null,
        name = json['name'],
        image = json['image'],
        quantity = json['quantity'].toInt(),
        size = json['size'],
        topping = json.data()!.containsKey('topping') ? json['topping'] : null,
        note = json.data()!.containsKey('note') ? json['note'] : null,
        unitPrice = json['unitPrice'].toDouble();
}
