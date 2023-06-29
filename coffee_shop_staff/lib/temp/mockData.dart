import 'dart:math';

import 'package:coffee_shop_staff/services/models/order.dart';
import 'package:coffee_shop_staff/services/models/user.dart';
import 'package:coffee_shop_staff/utils/constants/order_enum.dart';

import '../services/models/address.dart';
import '../services/models/food.dart';
import '../services/models/location.dart';
import '../services/models/ordered_food.dart';
import '../services/models/size.dart';
import '../services/models/store.dart';
import '../services/models/topping.dart';

class FakeData {
  static Random random = Random();
  static User userMock = User(
    id: 'User1',
    name: 'Yau Boii',
    phoneNumber: '0101010101',
    store: storeMock,
    email: 'fuck@gm.co',
    isActive: true,
    avatarUrl: 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png',
    coverUrl: 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png',
  );

  static MLocation addressMock = MLocation(
    formattedAddress: 'Ha Noi something',
    lat: 1,
    lng: 1,
  );

  static Store storeMock = Store(
    id: 'Store1',
    sb: 'Coffee shop hehehe',
    address: addressMock,
    phone: '012345678',
    stateFood: {},
    stateTopping: {},
    images: [],
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

  static Food foodMock = Food(
    id: 'Food1',
    name: 'Food 1',
    price: 123000,
    description: 'Food description',
    sizes: List.generate(4, (index) => sizeMock),
    toppings: List.generate(4, (index) => toppingMock),
    images: List.generate(4,
        (index) => 'https://cdn-icons-png.flaticon.com/512/1377/1377194.png'),
  );

  static OrderedFood orderedFoodMock = OrderedFood(
    food: foodMock,
    amount: 5,
    size: sizeMock,
    toppings: List.generate(4, (index) => toppingMock),
  );

  static Order orderMock = Order(
    id: 'orderMock',
    user: userMock,
    store: storeMock,
    orderDate: DateTime.now(),
    pickupTime: DateTime.now(),
    productList: List.generate(5, (index) {
      orderedFoodMock.totalPrice = Random().nextInt(100000 + 1 - 0).toDouble();
      return orderedFoodMock;
    }),
    status: OrderStatus.deliverFailed,
  );
}
