import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/size.dart';
import '../models/store.dart';

class SizeAPI {
  //singleton
  static final SizeAPI _sizeAPI = SizeAPI._internal();
  factory SizeAPI() {
    return _sizeAPI;
  }
  SizeAPI._internal();

  final firestore = FirebaseFirestore.instance;

  Map<String, Size> allSize = {};

  Size? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;
    return Size(
      id: id,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      image: data['image'],
    );
  }

  Map<String, dynamic> toFireStore(Store store) {
    final data = <String, dynamic>{};
    return data;
  }

  Future<Size?> get(String id) async {
    if (allSize.containsKey(id)) {
      return allSize[id];
    }
    var raw = await firestore.collection('Size').doc(id).get();
    var data = raw.data();
    var res = fromFireStore(data, id);
    if (res != null) {
      allSize[id] = res;
    }
    return res;
  }

  Future<List<Size>?> getList(List<String> listId) async {
    List<Size>? res = [];
    for (var item in listId) {
      var temp = await get(item);
      if (temp != null) {
        res.add(temp);
      }
    }
    if (res.isEmpty) {
      return null;
    }
    return res;
  }
}
