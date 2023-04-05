class DrinkSize {
  final String size;
  final String image;
  final String increasePrice;

  DrinkSize(
      {required this.size,
      this.increasePrice = '0',
      this.image =
          'https://product.hstatic.net/1000075078/product/latte_851143_08763e69fe3942ceaf3586ef97e1836d.jpg'});
}

class Topping {
  final String name;
  final String image;
  final String increasePrice;
  Topping(
      {required this.name,
      this.image =
          'https://product.hstatic.net/1000075078/product/espressonong_612688_2a3eddbcaaec4c9597a4091864496de9.jpg',
      this.increasePrice = '0'});
}
