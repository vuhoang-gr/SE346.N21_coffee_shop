import 'package:coffee_shop_app/services/models/location.dart';

import '../services/models/delivery_address.dart';
import '../services/models/size.dart';
import '../services/models/topping.dart';

class Data {
  static const name = "Nguyen Van A";
  static const phone = "01234567890";
  
  static final List<Size> sizes = [
    Size(
        name: 'Small',
        id: '1',
        image:
            'https://product.hstatic.net/1000075078/product/cold-brew-sua-tuoi_379576_7fd130b7d162497a950503207876ef64.jpg',
        price: 10),
    Size(
      name: 'Large',
      image:
          'https://product.hstatic.net/1000075078/product/cold-brew-sua-tuoi_379576_7fd130b7d162497a950503207876ef64.jpg',
      id: '2',
      price: 20,
    )
  ];
  static final List<Topping> toopings = [
    Topping(
        name: 'Espresso (1 shot)',
        price: 10,
        id: '1',
        image:
            'https://product.hstatic.net/1000075078/product/1645969436_caramel-macchiato-nong-lifestyle-1_187d60b2a52244c58a5c2fd24addef78.jpg'),
    Topping(
      name: 'Caramel',
      image:
          'https://product.hstatic.net/1000075078/product/1645969436_caramel-macchiato-nong-lifestyle-1_187d60b2a52244c58a5c2fd24addef78.jpg',
      id: '2',
      price: 5,
    )
  ];
  // static final List<Food> products = [
  //   Food(
  //       id: "food1",
  //       name: "Food 1",
  //       price: 1234.53,
  //       description: "Day la food 1",
  //       sizes: [
  //         Data.sizes[0],
  //         Data.sizes[1],
  //       ],
  //       toppings: [
  //         Data.toopings[0],
  //         Data.toopings[1],
  //       ],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: true,
  //       isFavorite: true,
  //       dateRegister: DateTime(2023, 5, 15)),
  //   Food(
  //       id: "food2",
  //       name: "Food 2",
  //       price: 1234.53,
  //       description: "Day la food 2",
  //       sizes: [
  //         Data.sizes[0],
  //       ],
  //       toppings: [
  //         Data.toopings[0],
  //         Data.toopings[1],
  //       ],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: false,
  //       dateRegister: DateTime(2023, 5, 15)),
  //   Food(
  //       id: "food3",
  //       name: "Food 3",
  //       price: 1234.53,
  //       description: "Day la food 3",
  //       sizes: [
  //         Data.sizes[0],
  //         Data.sizes[1],
  //       ],
  //       toppings: [],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: false,
  //       isFavorite: true,
  //       dateRegister: DateTime(2023, 4, 15)),
  //   Food(
  //       id: "food4",
  //       name: "Food 4",
  //       price: 1234.53,
  //       description: "Day la food 4",
  //       sizes: [
  //         Data.sizes[1],
  //       ],
  //       toppings: [
  //         Data.toopings[0],
  //         Data.toopings[1],
  //       ],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: true,
  //       dateRegister: DateTime(2023, 4, 15)),
  //   Food(
  //       id: "food5",
  //       name: "Food 5",
  //       price: 1234.53,
  //       description: "Day la food 5",
  //       sizes: [
  //         Data.sizes[0],
  //       ],
  //       toppings: [],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: true,
  //       dateRegister: DateTime(2023, 4, 15)),
  //   Food(
  //       id: "food6",
  //       name: "Food 6",
  //       price: 1234.53,
  //       description: "Day la food 6",
  //       sizes: [
  //         Data.sizes[0],
  //         Data.sizes[1],
  //       ],
  //       toppings: [
  //         Data.toopings[0],
  //         Data.toopings[1],
  //       ],
  //       images: [
  //         "https://phunugioi.com/wp-content/uploads/2022/02/Anh-Do-An-Cute-2.jpg"
  //       ],
  //       isAvailable: true,
  //       dateRegister: DateTime(2023, 4, 15)),
  // ];

  // static final List<Store> stores = [
  //   Store(
  //       id: "st01",
  //       sb: "The Coffee House - Hoàng Diệu 2",
  //       address: MLocation(
  //           formattedAddress:
  //               '66E Đ. Hoàng Diệu 2, Phường Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh 700000, Việt Nam',
  //           lat: 10.859665592985602,
  //           lng: 106.76683457652881),
  //       phone: "01234567890",
  //       isFavorite: true),
  //   Store(
  //       id: "st02",
  //       sb: "The Coffee House - Tô Ngọc Vân",
  //       address: MLocation(
  //           formattedAddress:
  //               '116 Tô Ngọc Vân, Linh Tây, TP Thủ Đức, Thành phố Hồ Chí Minh, Việt Nam',
  //           lat: 10.858316892414416,
  //           lng: 106.75172837615054),
  //       phone: "01234567890"),
  //   Store(
  //       id: "st03",
  //       sb: "The Coffee House - Đặng Văn Bi",
  //       address: MLocation(
  //           formattedAddress:
  //               '201 Đặng Văn Bi, Bình Thọ, Thủ Đức, Thành phố Hồ Chí Minh, Việt Nam',
  //           lat: 10.84348078437171,
  //           lng: 106.75722153992446),
  //       phone: "01234567890"),
  // ];

  static final List<DeliveryAddress> addresses = [
    DeliveryAddress(
        address: MLocation(
            formattedAddress:
                "Đường Hàn Thuyên, khu phố 6 P, Thủ Đức, Thành phố Hồ Chí Minh, Việt Nam",
            lat: 10.87002512137537,
            lng: 106.80305394044481),
        addressNote: "",
        nameReceiver: "Nguyen Van B",
        phone: "01234501232"),
  ];
}
