import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout/menu/menu_model.dart';
import 'package:nexttakeout/order/order_model.dart';
import 'package:uuid/uuid.dart';

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

  Future<OrderModel> placeOrder(String userId, String businessId,
      String productCode, double price) async {
    Uuid uuid = new Uuid();
    String newOrderId = uuid.v1();
    OrderModel newOrder = new OrderModel(newOrderId, userId, businessId,
        productCode, price, null, null, DateTime.now());
    // write order to both business and customer collection
    var businessObj =
        await _firestore.collection('/businesses').document(businessId);
    var customerObj = await _firestore.collection('/users').document(userId);

    businessObj.setData({
      'orders': FieldValue.arrayUnion([newOrder.toJson()])
    }, merge: true);
    customerObj.setData({
      'orders': FieldValue.arrayUnion([newOrder.toJson()])
    }, merge: true);

    return newOrder;
  }
}
