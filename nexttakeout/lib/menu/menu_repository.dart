import 'package:nexttakeout/common/global_object.dart' as globals;
import 'package:nexttakeout/menu/menu_model.dart';
import 'package:nexttakeout/menu/menu_provider.dart';
import 'package:nexttakeout/order/order_item_model.dart';
import 'package:nexttakeout/order/order_model.dart';
import 'package:uuid/uuid.dart';

class MenuRepository {
  final MenuProvider _menuProvider = MenuProvider();

  MenuRepository();

  void test(bool isError) {
    _menuProvider.test(isError);
  }

  Future<List<MenuModel>> fetchMenuItems(String businessId) async {
    return await _menuProvider.fetchMenuItems(businessId);
  }

  Future<OrderModel> placeNewOrder(
      String businessId, String productCode, double price, int maxQuantity) async {
    return await _menuProvider.placeOrder(
        globals.currentUserId, businessId, productCode, price, maxQuantity);
  }

  Future<void> placeNewOrderItem(
      String businessId, OrderItemModel newOrderItem) async {
    await _menuProvider.placeNewOrderItem(
        businessId, globals.currentUserId, newOrderItem);
  }

  void updateOrder(OrderModel newOrder) {
    _menuProvider.updateOrder(newOrder);
  }
}
