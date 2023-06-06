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

  Stream<List<Promo>> fetchData() {
    return promoReference.snapshots().map<List<Promo>>((snapshot) {
      List<Promo> promos = [];

      DateTime dateTimeNow = DateTime.now();
      List<QueryDocumentSnapshot?> docs = snapshot.docs;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['dateEnd'].toDate().isAfter(dateTimeNow)) {
          Promo? promo = fromFireStore(data, doc.id);
          if (promo != null) {
            promos.add(promo);
          }
        }
      }
      promos.sort((a, b) => a.dateEnd.compareTo(b.dateEnd));
      return promos;
    });
  }

  Promo? fromFireStore(Map<String, dynamic>? data, String id) {
    if (data == null) return null;

    return Promo(
        id: id,
        minPrice: data['minPrice'].toDouble(),
        maxPrice: data['maxPrice'].toDouble(),
        percent: data['percent'].toDouble(),
        description: data['description'],
        dateEnd: data['dateEnd'].toDate(),
        products: data['products'].cast<String>(),
        stores: data['stores'].cast<String>(),
        forNewCustomer: data['forNewCustomer']);
  }
}
