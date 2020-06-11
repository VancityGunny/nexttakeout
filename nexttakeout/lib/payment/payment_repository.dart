import 'package:nexttakeout/payment/index.dart';

class PaymentRepository {
  final PaymentProvider _paymentProvider = PaymentProvider();

  PaymentRepository();

  void test(bool isError) {
    _paymentProvider.test(isError);
  }
}