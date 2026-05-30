import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/UserProfile.dart';

class RoleProvider extends ChangeNotifier {
  String _role = 'client';
  UserProfile? _userProfile;
  bool _isLoading = false;

  String get role => _role;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  bool get isAdmin => _role == 'admin';
  bool get isExecutive =>
      _role == 'executive' || _role == 'worker' || _role == 'engineer';
  bool get isClient => _role == 'client' || _role == 'user';

  // Legacy aliases
  bool get isWorker => isExecutive;
  bool get isUser => isClient;

  /// Fetch user role and full profile from Firestore
  Future<void> fetchUserRole() async {
    try {
      _isLoading = true;
      notifyListeners();

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        _role = doc['role'] ?? 'client';
        _userProfile = UserProfile.fromMap(uid, doc.data() ?? {});
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile (for executives to update their designation, etc.)
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updates);

      // Refresh profile
      await fetchUserRole();
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }
}