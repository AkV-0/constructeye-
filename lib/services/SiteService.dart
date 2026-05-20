import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/SiteModel.dart';

class SiteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference _userSiteCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('sites');

  Future<void> addSite(SiteModel site) async {
    final owner = site.ownerId.isNotEmpty ? site.ownerId : userId;
    await _userSiteCollection(owner).add(site.toMap());
  }

  Future<List<SiteModel>> fetchUserSites() async {
    final snapshot = await _userSiteCollection(userId).get();

    return snapshot.docs.map((doc) {
      return SiteModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<SiteModel>> fetchAllSites() async {
    final snapshot = await _firestore
        .collectionGroup('sites')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final map = doc.data() as Map<String, dynamic>;
      final ownerId = map['ownerId'] ?? doc.reference.parent.parent?.id ?? '';
      return SiteModel.fromMap({...map, 'ownerId': ownerId}, doc.id);
    }).toList();
  }

  Future<List<SiteModel>> fetchAssignedSites(String uid) async {
    final assignedSnapshot = await _firestore
        .collectionGroup('sites')
        .where('assignedTo', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    final ownerSnapshot = await _firestore
        .collectionGroup('sites')
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    final Map<String, QueryDocumentSnapshot> documents = {};

    for (final doc in assignedSnapshot.docs) {
      documents[doc.reference.path] = doc;
    }

    for (final doc in ownerSnapshot.docs) {
      documents[doc.reference.path] = doc;
    }

    return documents.values.map((doc) {
      final map = doc.data() as Map<String, dynamic>;
      final ownerId = map['ownerId'] ?? doc.reference.parent.parent?.id ?? '';
      return SiteModel.fromMap({...map, 'ownerId': ownerId}, doc.id);
    }).toList();
  }

  Future<void> deleteSite(SiteModel site) async {
    final owner = site.ownerId.isNotEmpty ? site.ownerId : userId;
    await _userSiteCollection(owner).doc(site.id).delete();
  }

  Future<void> updateSite(SiteModel site) async {
    final owner = site.ownerId.isNotEmpty ? site.ownerId : userId;
    await _userSiteCollection(owner).doc(site.id).update(site.toMap());
  }
}
