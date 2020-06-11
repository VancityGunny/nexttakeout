import 'package:nexttakeout/place_order/index.dart';

class PlaceOrderRepository {
  final PlaceOrderProvider _placeOrderProvider = PlaceOrderProvider();

  PlaceOrderRepository();

  void test(bool isError) {
    _placeOrderProvider.test(isError);
  }
}