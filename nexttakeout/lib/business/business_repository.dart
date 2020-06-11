
import 'package:nexttakeout/business/index.dart';
import 'package:uuid/uuid.dart';
import 'package:nexttakeout/common/global_object.dart' as globals;


class BusinessRepository {
  final BusinessProvider _businessProvider = BusinessProvider();

  BusinessRepository();

  Future<String> addBusiness(BusinessModel newBusiness) async {
    var uuid = new Uuid();
    var newBusinessId = uuid.v1();
    newBusiness.id = newBusinessId;
    await _businessProvider.addBusiness(newBusiness);
    return newBusinessId.toString();
  }

  Future<String> getBusinessId() async {
    return await _businessProvider.getBusinessId(globals.currentUserId);
  }

  Future<List<BusinessModel>> getNearbyBusinesses() async{
    //TODO: implement actual within range
    return await _businessProvider.getNearbyBusinesses();
  }
}
