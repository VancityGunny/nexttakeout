import 'package:nexttakeout_seller/order/index.dart';

import 'order_item_model.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class OrderRepository {
  final OrderProvider _orderProvider = OrderProvider();

  OrderRepository();

  void test(bool isError) {
    _orderProvider.test(isError);
  }

  void updateOrderItems(List<OrderItemModel> orderItems) async {
    await _orderProvider.updateOrderItems(
        globals.currentBusinessId, orderItems);
  }
  void updateSpecificOrderItem(OrderItemModel orderItem) async {
    await _orderProvider.updateSpecificOrderItem(
        globals.currentBusinessId, orderItem);
  }
}
