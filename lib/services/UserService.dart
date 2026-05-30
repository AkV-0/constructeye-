import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/UserProfile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  Future<void> createUserProfile(User user, {String role = 'client'}) async {
    final doc = _usersCollection.doc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set(
        UserProfile(uid: user.uid, email: user.email ?? '', role: role).toMap(),
      );
    }
  }

  Future<UserProfile?> fetchUserProfile(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    if (!snapshot.exists) return null;
    return UserProfile.fromMap(uid, snapshot.data() as Map<String, dynamic>);
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _usersCollection.doc(uid).update({'role': role});
  }
}
