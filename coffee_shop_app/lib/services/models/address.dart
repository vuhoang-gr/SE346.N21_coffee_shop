class Address {
  String city;
  String district;
  String ward;
  String shortName;

  Address({
    required this.city,
    required this.district,
    required this.ward,
    required this.shortName,
  });

  @override
  String toString() {
    return "$shortName, $ward, $district, $city";
  }
}
