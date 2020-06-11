import 'package:nexttakeout_seller/business/business_model.dart';
import 'package:nexttakeout_seller/business/business_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class BusinessRepository {
  final BusinessProvider _businessProvider = BusinessProvider();

  BusinessRepository();

  Future<String> addBusiness(BusinessModel newBusiness) async {
    var uuid = new Uuid();
    var newBusinessId = uuid.v1();
    newBusiness.id = newBusinessId;
    await _businessProvider.addBusiness(newBusiness);
    globals.currentBusinessId = newBusinessId;
    return newBusinessId.toString();
  }

  Future<String> getBusinessId() async {
    return await _businessProvider.getBusinessId(globals.currentUserId);
  }
}
