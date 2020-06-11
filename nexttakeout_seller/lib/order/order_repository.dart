import 'package:nexttakeout_seller/order/index.dart';

class OrderRepository {
  final OrderProvider _orderProvider = OrderProvider();

  OrderRepository();

  void test(bool isError) {
    _orderProvider.test(isError);
  }
}