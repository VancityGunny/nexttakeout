import 'package:nexttakeout/menu_search/index.dart';

class MenuSearchRepository {
  final MenuSearchProvider _menuSearchProvider = MenuSearchProvider();

  MenuSearchRepository();

  void test(bool isError) {
    _menuSearchProvider.test(isError);
  }
}