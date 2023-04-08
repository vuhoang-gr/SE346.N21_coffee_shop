

import '../services/models/address.dart';
import '../services/models/delivery_address.dart';
import '../services/models/food.dart';
import '../services/models/store.dart';

class Data {
  static const name = "Nguyen Van A";
  static final List<Food> products = [
    Food(
        id: "food1",
        name: "Food 1",
        price: 1234.53,
        description: "Day la food 1",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food2",
        name: "Food 2",
        price: 1234.53,
        description: "Day la food 2",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food3",
        name: "Food 3",
        price: 1234.53,
        description: "Day la food 3",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food4",
        name: "Food 4",
        price: 1234.53,
        description: "Day la food 4",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food5",
        name: "Food 5",
        price: 1234.53,
        description: "Day la food 5",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food6",
        name: "Food 6",
        price: 1234.53,
        description: "Day la food 6",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
  ];

  static final List<Food> favoriteProducts = [
    Food(
        id: "food1",
        name: "Food 1",
        price: 1234.53,
        description: "Day la food 1",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
    Food(
        id: "food4",
        name: "Food 4",
        price: 1234.53,
        description: "Day la food 4",
        sizes: null,
        toppings: null,
        images: [
          "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
        ]),
  ];

  static final List<Store> storeAddress = [
    Store(
        id: "st01",
        sb: "Store 1",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 1"),
        phone: "01234567890"),
    Store(
        id: "st02",
        sb: "Store 2",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 2"),
        phone: "01234567890"),
    Store(
        id: "st03",
        sb: "Store 3",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 3"),
        phone: "01234567890"),
    Store(
        id: "st04",
        sb: "Store 4",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 4"),
        phone: "01234567890"),
    Store(
        id: "st05",
        sb: "Store 5",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 5"),
        phone: "01234567890"),
  ];
  static final List<Store> favoriteStores = [
    Store(
        id: "st01",
        sb: "Store 1",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 1"),
        phone: "01234567890"),
    Store(
        id: "st05",
        sb: "Store 5",
        address: Address(
            city: "HCM city",
            district: "Thu Duc",
            ward: "Linh Trung",
            shortName: "short Name 5"),
        phone: "01234567890"),
  ];

  static final List<DeliveryAddress> addresses = [
    DeliveryAddress(
      address: Address(
          city: "HCM city",
          district: "Thu Duc",
          ward: "khong biet",
          shortName: "123 xa lo Ha Noi"),
      nameReceiver: "Nguyen Van B", phone: "01234501232"),
    DeliveryAddress(
      address: Address(
          city: "HCM city",
          district: "Binh Thanh",
          ward: "phuong 25",
          shortName: "123 xa lo Ha Noi"),
      nameReceiver: "Nguyen Van B", phone: "01234501232"),
    DeliveryAddress(
      address: Address(
          city: "HCM city",
          district: "Binh Thanh",
          ward: "phuong 26",
          shortName: "123 xa lo Ha Noi"),
      nameReceiver: "Nguyen Van C", phone: "01234501232"),
  ];
}
