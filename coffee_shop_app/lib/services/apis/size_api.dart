import 'package:coffee_shop_app/widgets/global/cart_button.dart';

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
        id: id,
        name: data['name'],
        price: data['price'].toDouble(),
        image: data['image']);
  }

  Future<List<Size>> changeRefToObject(
      List<dynamic> sizes, List<String>? bannedSize) async {
    List<Size> results = [];
    for (var sizeRef in sizes) {
      var doc = await sizeRef.get();
      if (doc != null) {
        if (bannedSize != null && bannedSize.contains(doc.id)) {
          continue;
        }
        Size? size = fromFireStore(doc.data() as Map<String, dynamic>, doc.id);
        if (size != null) {
          results.add(size);
        }
      }
    }
    return results;
  }
}
