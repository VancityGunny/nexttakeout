import 'package:nexttakeout_seller/scanbarcode/index.dart';

class ScanbarcodeRepository {
  final ScanbarcodeProvider _scanbarcodeProvider = ScanbarcodeProvider();

  ScanbarcodeRepository();

  void test(bool isError) {
    _scanbarcodeProvider.test(isError);
  }
}