class MLocation {
  String formattedAddress;
  double lat;
  double lng;

  MLocation(
      {required this.formattedAddress, required this.lat, required this.lng});

  factory MLocation.fromJson(Map<String, dynamic> map) {
    return MLocation(
      formattedAddress: map['place_name_vi'],
      lat: map['geometry']['coordinates'][1],
      lng: map['geometry']['coordinates'][0],
    );
  }

  static List<MLocation> parseLocationList(map) {
    var list = map['features'] as List;
    return list.map((location) => MLocation.fromJson(location)).toList();
  }
}
