import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;

class PhotoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  /// Uploads a photo to Firebase Storage and saves its metadata to Firestore.
  Future<String> uploadPhoto({
    required File file,
    required String siteId,
    String? description,
  }) async {
    if (userId.isEmpty) throw Exception("User not authenticated");

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final storageRef = _storage.ref().child('sites/$siteId/photos/$fileName');

    // 1. Upload file to Firebase Storage
    final uploadTask = await storageRef.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // 2. Save metadata to Firestore
    await _firestore.collection('photos').add({
      'siteId': siteId,
      'url': downloadUrl,
      'uploadedBy': userId,
      'uploadedAt': FieldValue.serverTimestamp(),
      'description': description ?? '',
      'fileName': fileName,
    });

    return downloadUrl;
  }

  /// Fetches all photos for a specific site.
  Future<List<Map<String, dynamic>>> fetchSitePhotos(String siteId) async {
    final snapshot = await _firestore
        .collection('photos')
        .where('siteId', isEqualTo: siteId)
        .orderBy('uploadedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  /// Deletes a photo from Storage and Firestore.
  Future<void> deletePhoto(String photoId, String storageUrl) async {
    // 1. Delete from Storage
    await _storage.refFromURL(storageUrl).delete();

    // 2. Delete from Firestore
    await _firestore.collection('photos').doc(photoId).delete();
  }
}
