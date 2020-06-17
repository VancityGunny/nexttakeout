import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nexttakeout/menu/menu_model.dart';

/// generate by https://javiercbk.github.io/json_to_dart/
class AutogeneratedOrderItem {
  final List<OrderItemModel> results;

  AutogeneratedOrderItem({this.results});

  factory AutogeneratedOrderItem.fromJson(Map<String, dynamic> json) {
    List<OrderItemModel> temp;
    if (json['results'] != null) {
      temp = <OrderItemModel>[];
      json['results'].forEach((v) {
        temp.add(OrderItemModel.fromJson(v as Map<String, dynamic>));
      });
    }
    return AutogeneratedOrderItem(results: temp);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemModel extends Equatable {
  String orderItemId;
  String orderId;
  MenuModel menuOrdered;
  DateTime orderedDate;
  DateTime pickupDate;
  String orderStatus; // Pending, Ready, Completed
  String customerName;
  String customerId;
  
  OrderItemModel(this.orderItemId, this.orderId, this.menuOrdered, this.orderedDate, this.pickupDate, this.orderStatus, this.customerName, this.customerId);

  @override
  List<Object> get props =>
      [orderItemId, orderId, menuOrdered, orderedDate, pickupDate, orderStatus, customerName, customerId];

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
        json['orderItemId'] as String,
        json['orderId'] as String,
        MenuModel.fromJson(json['menuOrdered']),
        json['orderedDate'].toDate() as DateTime,
        json['pickupDate'].toDate() as DateTime,
        json['orderStatus'] as String,
        json['customerName'] as String,
        json['customerId'] as String
        );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderItemId'] = orderItemId;
    data['orderId'] = orderId;
    data['menuOrdered'] = menuOrdered.toJson();
    data['orderedDate'] = orderedDate;
    data['pickupDate'] = pickupDate;
    data['orderStatus'] = orderStatus;
    data['customerName'] = customerName;
    data['customerId'] = customerId;
    return data;
  }
}
