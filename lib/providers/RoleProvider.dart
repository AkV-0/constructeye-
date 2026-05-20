import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleProvider extends ChangeNotifier {
  String _role = 'user';

  String get role => _role;

  bool get isAdmin => _role == 'admin';

  bool get isWorker => _role == 'worker' || _role == 'engineer';

  bool get isUser => _role == 'user';

  Future<void> fetchUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        _role = doc['role'] ?? 'user';
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
