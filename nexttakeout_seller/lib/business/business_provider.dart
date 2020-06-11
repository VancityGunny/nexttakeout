import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/business/business_model.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class BusinessProvider {
  static final _firestore = Firestore.instance;

  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<String> addBusiness(BusinessModel newBusiness) async {
    // if it's not already exists then add new user first
    var newBusinessObj =
        _firestore.collection('/businesses').document(newBusiness.id);
    newBusinessObj.setData({
      'name': newBusiness.businessName,
      'address': newBusiness.address,
      'phone': newBusiness.phone,
      'imageUrl': newBusiness.photoUrl,
      'owner_user_id': newBusiness.ownerUserId
    });
    return newBusinessObj.documentID;
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }

  Future<String> getBusinessId(String currentUserId) async {
    var foundBusinesses = await _firestore
        .collection('/businesses')
        .where('owner_user_id', isEqualTo: currentUserId)
        .getDocuments();
    return (foundBusinesses.documents.first == null)
        ? null
        : foundBusinesses.documents.first.documentID;
  }
}
