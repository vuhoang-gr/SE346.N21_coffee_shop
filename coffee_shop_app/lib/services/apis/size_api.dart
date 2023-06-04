import '../models/size.dart';

class SizeApi {
  //singleton
  static final SizeApi _sizeAPI = SizeApi._internal();
  factory SizeApi() {
    return _sizeAPI;
  }
  SizeApi._internal();

  Size? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Size(
        id: id, name: data['name'], price: data['price'].toDouble(), image: data['image']);
  }
}
