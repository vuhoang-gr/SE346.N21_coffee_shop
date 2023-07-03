const double firstDistance = 10;
const double firstDistancePrice = 15000;
const double eachKmPrice = 3000;

double calShippingFee(double km) {
  if (km <= firstDistance) {
    return firstDistancePrice;
  } else {
    var price =
        (firstDistancePrice + (km.floor() - firstDistance) * eachKmPrice);
    return price > 50000 ? 50000 : price;
  }
}
