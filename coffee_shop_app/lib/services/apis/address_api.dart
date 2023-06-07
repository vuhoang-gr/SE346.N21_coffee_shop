import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/services/models/location.dart';

class AddressAPI {
  //singleton
  static final AddressAPI _addressAPI = AddressAPI._internal();
  factory AddressAPI() {
    return _addressAPI;
  }
  AddressAPI._internal();

  List<DeliveryAddress> currentAddresses = [];

  final firestore = FirebaseFirestore.instance;
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Stream<List<DeliveryAddress>> fetchData(String userId) {
    return userReference.doc(userId).snapshots().map((snapshot) {
      List<DeliveryAddress> deliveryAddresses = [];
      if (!snapshot.exists) {
        throw Error();
      }
      List<dynamic> addressData =
          (snapshot.data() as Map<String, dynamic>)['addresses'] ?? [];
      for (var address in addressData) {
        deliveryAddresses.add(fromFireStore(address));
      }

      currentAddresses = deliveryAddresses;
      
      return deliveryAddresses;
    });
  }

  Future<bool> push(String userId, DeliveryAddress deliveryAddress) async {
    try {
      final userDoc = await userReference.doc(userId).get();
      final addresses =
          (userDoc.data() as Map<String, dynamic>)['addresses'] ?? [];

      addresses.add(toFireStore(deliveryAddress));
      await userReference.doc(userId).update({'addresses': addresses});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(
      String userId, int index, DeliveryAddress deliveryAddress) async {
    try {
      final userDoc = await userReference.doc(userId).get();
      final addresses =
          (userDoc.data() as Map<String, dynamic>)['addresses'] ?? [];
      if (index >= 0 && index < addresses.length) {
        addresses[index] = toFireStore(deliveryAddress);
        await userReference.doc(userId).update({'addresses': addresses});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> remove(String userId, int index) async {
    try {
      final userDoc = await userReference.doc(userId).get();
      final addresses =
          (userDoc.data() as Map<String, dynamic>)['addresses'] ?? [];
      if (index >= 0 && index < addresses.length) {
        addresses.removeAt(index);
        await userReference.doc(userId).update({'addresses': addresses});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  DeliveryAddress fromFireStore(Map<String, dynamic> data) {
    return DeliveryAddress(
        address: MLocation(
            formattedAddress: data['formattedAddress'],
            lat: data['lat'].toDouble(),
            lng: data['lng'].toDouble()),
        addressNote: data['addressNote'],
        nameReceiver: data['nameReceiver'],
        phone: data['phone']);
  }

  Map<String, dynamic> toFireStore(DeliveryAddress deliveryAddress) {
    return {
      "formattedAddress": deliveryAddress.address.formattedAddress,
      "lat": deliveryAddress.address.lat,
      "lng": deliveryAddress.address.lng,
      "addressNote": deliveryAddress.addressNote,
      "nameReceiver": deliveryAddress.nameReceiver,
      "phone": deliveryAddress.phone
    };
  }
}
