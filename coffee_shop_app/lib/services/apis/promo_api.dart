import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/promo.dart';

class PromoAPI {
  //singleton
  static final PromoAPI _promoAPI = PromoAPI._internal();
  factory PromoAPI() {
    return _promoAPI;
  }
  PromoAPI._internal();

  final firestore = FirebaseFirestore.instance;
  final CollectionReference promoReference =
      FirebaseFirestore.instance.collection('Promo');

  Future<List<Promo>> fetchData() async {
    QuerySnapshot promoSnapshot = await promoReference.get();
    List<Promo> promos = [];

    for (QueryDocumentSnapshot doc in promoSnapshot.docs) {
      promos
          .add(await fromFireStore(doc.data() as Map<String, dynamic>, doc.id));
    }
    return promos;
  }

  Future<bool> usePromo(String promoId) async {
    try {
      final promoDocRef = promoReference.doc(promoId);
      DocumentSnapshot promoSnapshot = await promoDocRef.get();

      if (promoSnapshot.exists) {
        Map<String, dynamic> data =
            promoSnapshot.data() as Map<String, dynamic>;
        int currentNumberUsed = data['numberUsed'];
        int currentnumberTotal = data['numberTotal'];
        if (currentNumberUsed >= currentnumberTotal) {
          return false; 
        }

        await promoDocRef.update({'numberUsed': currentNumberUsed + 1});

        return true;
      }

      return false;
    } catch (e) {
      print('Error using promo: $e');
      return false;
    }
  }

  Future<Promo> fromFireStore(Map<String, dynamic> data, String id) async {
    List<dynamic> storeRefs = data['stores'];
    List<String> stores = [];
    for (int i = 0; i < storeRefs.length; i++) {
      var storeSnapshot = await storeRefs[i].get();
      stores.add(storeSnapshot.id);
    }

    List<dynamic> productRefs = data['products'];
    List<String> products = [];
    for (int i = 0; i < productRefs.length; i++) {
      var productSnapshot = await productRefs[i].get();
      products.add(productSnapshot.id);
    }

    return Promo(
        id: id,
        minPrice: data['minPrice'].toDouble(),
        maxPrice: data['maxPrice'].toDouble(),
        percent: data['percent'].toDouble(),
        numberTotal: data['numberTotal'],
        numberUsed: data['numberUsed'],
        dateBegin: data['dateBegin'].toDate(),
        dateEnd: data['dateEnd'].toDate(),
        products: products,
        stores: stores,
        typeCustomer: data['typeCustomer']);
  }
}
