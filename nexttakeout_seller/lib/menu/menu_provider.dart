import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/menu/index.dart';

class MenuProvider {
  static final _firestore = Firestore.instance;
  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }

  Future<List<MenuModel>> fetchMenuItems(String businessId) async {
    var menuItems =
        await _firestore.collection('/menu').document(businessId).get();
    var returnObj = (menuItems.data == null)
        ? new List<MenuModel>()
        : List<MenuModel>.from(
            menuItems.data["items"].map((m) => MenuModel.fromJson(m)));
    List<MenuModel> returnListObj = returnObj.toList();
    return returnListObj;
  }

  updateMenuItems(String businessId, List<MenuModel> menuItems) async {
    var foundBusinessObj =
        await _firestore.collection('/menu').document(businessId);

    foundBusinessObj
        .setData({'items': menuItems.map((e) => e.toJson()).toList()});
  }
}
