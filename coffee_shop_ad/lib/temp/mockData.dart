import 'dart:math';

import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:coffee_shop_admin/utils/constants/order_enum.dart';
import 'package:coffee_shop_admin/services/models/location.dart';

import '../services/models/drink.dart';
import '../services/models/size.dart';
import '../services/models/store.dart';
import '../services/models/topping.dart';

class FakeData {
  static Random random = Random();
  static User userMock = User(
    id: 'User1',
    name: 'Yau Boii',
    phoneNumber: '0101010101',
    email: 'fuck@gm.co',
    isActive: true,
    avatarUrl: 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png',
    coverUrl: 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png',
  );

  static Store storeMock = Store(
    id: "st01",
    sb: "The Coffee House - Hoàng Diệu 2",
    address: MLocation(
        formattedAddress:
            '66E Đ. Hoàng Diệu 2, Phường Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh 700000, Việt Nam',
        lat: 10.859665592985602,
        lng: 106.76683457652881),
    phone: "01234567890",
  );

  static Size sizeMock = Size(
    id: 'Size1',
    name: 'L',
    price: 10000,
    image: 'null',
  );

  static Topping toppingMock = Topping(
    id: 'Topping1',
    name: 'Topping 1',
    price: 1,
    image: 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png',
  );

  static Drink foodMock = Drink(
    id: 'Food1',
    name: 'Food 1',
    price: 123000,
    description: 'Food description',
    // sizes: List.generate(4, (index) => sizeMock),
    // toppings: List.generate(4, (index) => toppingMock),
    images: List.generate(4,
        (index) => 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png'),
  );

  // static Order orderMock = Order(
  //   id: 'orderMock',
  //   user: userMock,
  //   store: storeMock,
  //   orderDate: DateTime.now(),
  //   pickupTime: DateTime.now(),
  //   productList: List.generate(5, (index) {
  //     orderedFoodMock.totalPrice = Random().nextInt(100000 + 1 - 0).toDouble();
  //     return orderedFoodMock;
  //   }),
  //   status: OrderStatus.deliverFailed,
  // );
}
