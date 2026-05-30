import 'package:firebase_auth/firebase_auth.dart';

import 'UserService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP

  Future<User?> signUp(String email, String password, {String role = 'client'}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        await UserService().createUserProfile(user, role: role);
      }
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // LOGIN

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final profile = await UserService().fetchUserProfile(user.uid);
    return profile?.role;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // LOGOUT

  Future<void> logout() async {
    await _auth.signOut();
  }
}
