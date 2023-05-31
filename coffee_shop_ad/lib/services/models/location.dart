class MLocation {
  String formattedAddress;
  double lat;
  double lng;

  MLocation(
      {required this.formattedAddress,
      required this.lat,
      required this.lng});

  factory MLocation.fromJson(Map<String, dynamic> map) {
    return MLocation(
      formattedAddress: map['formatted_address'],
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
    );
  }

  static List<MLocation> parseLocationList(map) {
    var list = map['results'] as List;
    return list.map((movie) => MLocation.fromJson(movie)).toList();
  }
}
