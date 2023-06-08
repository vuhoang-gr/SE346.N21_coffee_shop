import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/size.dart';

class SizeApi {
  //singleton
  static final SizeApi _sizeAPI = SizeApi._internal();
  factory SizeApi() {
    return _sizeAPI;
  }
  SizeApi._internal();

  List<Size> currentSizes = [];

  final CollectionReference sizeReference =
      FirebaseFirestore.instance.collection('Size');

  Stream<List<Size>> fetchData() {
    return sizeReference.snapshots().map<List<Size>>((snapshot) {
      List<Size> sizes = [];
      for (var doc in snapshot.docs) {
        Size? size = fromFireStore(doc.data() as Map<String, dynamic>?, doc.id);
        if (size != null) {
          sizes.add(size);
        }
      }
      sizes.sort((a, b) => a.price.compareTo(b.price));
      currentSizes = sizes;
      return sizes;
    });
  }

  Size? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Size(
        id: id,
        name: data['name'],
        price: data['price'].toDouble(),
        image: data['image']);
  }
}
