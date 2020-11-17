import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firebaseUser = Rx<User>();
  final _isLoggedIn = false.obs;


  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  User get user => _firebaseUser.value;
  FirebaseAuth get auth => _auth;
  bool get loggedIn => _isLoggedIn.value;

  set loggedIn(bool val) => this._isLoggedIn.value = val;

  void signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      Get.snackbar("Error signing out", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }
}