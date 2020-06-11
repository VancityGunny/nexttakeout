library my_prj.globals;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexttakeout_seller/user/user_model.dart';
import 'package:path_provider/path_provider.dart';

UserModel loggedInUser;
String currentUserId;
FirebaseStorage storage = FirebaseStorage.instance;
String currentBusinessId;

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
