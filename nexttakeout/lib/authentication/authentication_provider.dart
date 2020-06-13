import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexttakeout/user/user_model.dart';
import 'package:nexttakeout/common/global_object.dart' as globals;

class AuthProvider {
  static final _firestore = Firestore.instance;

  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<String> addUser(UserModel newUser) async {
    // if it's not already exists then add new user first
    var newUserObj = _firestore.collection('/users').document(newUser.id);
    newUserObj.setData({
      'uid': newUser.uid,
      'email': newUser.email,
      'phone': newUser.phone,
      'displayName': newUser.displayName
    });
    return newUserObj.documentID;
  }

  Future<UserModel> getUserByUid(String uid) async {
    var foundUsers = await _firestore
        .collection('/users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (foundUsers.documents.length <= 0) {
      return null;
    }
    UserModel foundUser = UserModel.fromJson(foundUsers.documents.first.data);
    foundUser.id = foundUsers.documents.first.documentID;
    return foundUser;
  }

  Future<UserModel> getUserByEmail(String email) async {
    var foundUsers = await _firestore
        .collection('/users')
        .where('email', isEqualTo: email)
        .getDocuments();
    if (foundUsers.documents.length <= 0) {
      return null;
    }

    return UserModel.fromJson(foundUsers.documents.first.data);
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }
}
