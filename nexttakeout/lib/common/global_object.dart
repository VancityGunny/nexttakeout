library my_prj.globals;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexttakeout/user/user_model.dart';


UserModel loggedInUser;
String currentUserId;
String currentUserDisplayName;
FirebaseStorage storage = FirebaseStorage.instance;