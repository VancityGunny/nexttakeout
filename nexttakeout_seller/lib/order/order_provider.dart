import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout_seller/order/order_item_model.dart';

class OrderProvider {
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

  void updateOrderItems(
      String businessId, List<OrderItemModel> orderItems) async {
    var foundBusinessObj =
        _firestore.collection('/businessOrders').document(businessId);

    foundBusinessObj
        .setData({'orderItems': orderItems.map((e) => e.toJson()).toList()});
  }

  void updateSpecificOrderItem(
      String businessId, OrderItemModel orderItem) async {
    var foundBusinessObj =
        _firestore.collection('/businessOrders').document(businessId);
    var currentOrderItems = (await foundBusinessObj.get()).data['orderItems'];
    List<OrderItemModel> tempList = new List<OrderItemModel>();
    currentOrderItems.forEach((f) {
      var tempObj = OrderItemModel.fromJson(f);
      if (tempObj.orderItemId == orderItem.orderItemId) {
        tempList.add(orderItem);
      } else {
        tempList.add(tempObj);
      }
    });

    foundBusinessObj
        .setData({'orderItems': tempList.map((e) => e.toJson()).toList()});

    // now update user order too
    var foundUserOrderObj =
        _firestore.collection('/userOrders').document(orderItem.customerId);
    currentOrderItems = (await foundBusinessObj.get()).data['orderItems'];
    tempList = new List<OrderItemModel>();
    currentOrderItems.forEach((f) {
      var tempObj = OrderItemModel.fromJson(f);
      if (tempObj.orderItemId == orderItem.orderItemId) {
        tempList.add(orderItem);
      } else {
        tempList.add(tempObj);
      }
    });

    foundUserOrderObj
        .setData({'orderItems': tempList.map((e) => e.toJson()).toList()});
  }
}
