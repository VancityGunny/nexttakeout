import 'package:nexttakeout/pickup_order/index.dart';

class PickupOrderRepository {
  final PickupOrderProvider _pickupOrderProvider = PickupOrderProvider();

  PickupOrderRepository();

  void test(bool isError) {
    _pickupOrderProvider.test(isError);
  }
}