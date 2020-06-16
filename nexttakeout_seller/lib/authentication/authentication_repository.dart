import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexttakeout_seller/authentication/index.dart';
import 'package:nexttakeout_seller/user/user_model.dart';
import 'package:nexttakeout_seller/common/global_object.dart' as globals;
import 'package:uuid/uuid.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  void test(bool isError) {
    _authProvider.test(isError);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }

  Future<UserModel> getUserByUid(String uid) async {
    var loggedInUser = await _authProvider.getUserByUid(uid);
    if (loggedInUser == null) {
      return null;
    }
    globals.loggedInUser = loggedInUser;
    globals.currentUserId = loggedInUser.id;
    return loggedInUser;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    var user = await _firebaseAuth.currentUser();

    return user;
  }

  /// return new userId
  Future<String> addUserFromFirebaseUser(FirebaseUser user) async {
    var uuid = new Uuid();
    var userId = uuid.v1();
    await _authProvider.addUser(new UserModel(userId.toString(), user.uid,
        user.email, user.displayName, user.phoneNumber, user.photoUrl));
    globals.currentUserId = userId;
    return userId.toString();
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
