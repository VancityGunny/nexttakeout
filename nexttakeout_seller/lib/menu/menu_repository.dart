import 'package:nexttakeout_seller/menu/index.dart';

import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class MenuRepository {
  final MenuProvider _menuProvider = MenuProvider();

  MenuRepository();

  void test(bool isError) {
    _menuProvider.test(isError);
  }

  Future<List<MenuModel>> fetchMenuItems() async {
    return await _menuProvider.fetchMenuItems(globals.currentBusinessId);
  }



  void updateMenuItems(List<MenuModel> menuItems) async{
    await _menuProvider.updateMenuItems(globals.currentBusinessId, menuItems);
  }
}
