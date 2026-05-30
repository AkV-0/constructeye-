import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/PhotoModel.dart';

class PhotoProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<PhotoModel> _photos = [];
  List<PhotoModel> _allPhotos = [];
  bool _isLoading = false;

  List<PhotoModel> get photos => _photos;
  List<PhotoModel> get allPhotos => _allPhotos;
  bool get isLoading => _isLoading;

  Future<void> fetchPhotosBySite(String siteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('photos')
          .where('siteId', isEqualTo: siteId)
          .orderBy('uploadedAt', descending: true)
          .get();

      _photos = snapshot.docs
          .map((doc) => PhotoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching photos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllPhotos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('photos')
          .orderBy('uploadedAt', descending: true)
          .get();

      _photos = snapshot.docs
          .map((doc) => PhotoModel.fromMap(doc.data(), doc.id))
          .toList();
      _allPhotos = List.from(_photos);
    } catch (e) {
      debugPrint('Error fetching photos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> uploadPhoto(
    String siteId,
    Uint8List fileBytes,
    String caption, {
    String? description,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final fileName = 'photos/$siteId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      debugPrint('Attempting to upload to: $fileName');
      
      final storageRef = _storage.ref().child(fileName);

      // Using putData instead of putFile for Web compatibility
      final uploadTask = storageRef.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Listen to progress for debugging
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          debugPrint('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        },
        onError: (e) {
          debugPrint('Upload task error: $e');
        },
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('Upload successful. URL: $downloadUrl');

      final photoDoc = PhotoModel(
        id: '',
        siteId: siteId,
        url: downloadUrl,
        caption: caption,
        uploadedAt: DateTime.now(),
        uploadedBy: user.email ?? user.uid,
        description: description,
      );

      final docRef = await _firestore
          .collection('photos')
          .add(photoDoc.toMap());

      final newPhoto = photoDoc.copyWith(id: docRef.id);
      _photos.insert(0, newPhoto);
      _allPhotos.insert(0, newPhoto);

      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error uploading photo: $e');
      
      String errorMsg = 'Failed to upload photo';
      if (e.toString().contains('storage/unauthorized')) {
        errorMsg = 'Firebase Storage Permission Denied. Please check your security rules.';
      } else if (e.toString().contains('storage/canceled')) {
        errorMsg = 'Upload was canceled.';
      } else if (e.toString().contains('storage/retry-limit-exceeded')) {
        errorMsg = 'Upload timed out. Please try a smaller image or better connection.';
      }
      
      throw Exception('$errorMsg ($e)');
    }
  }

  Future<void> deletePhoto(String photoId, String photoUrl) async {
    try {
      // Delete from Firestore
      await _firestore.collection('photos').doc(photoId).delete();

      // Delete from Storage
      try {
        final storageRef = FirebaseStorage.instance.refFromURL(photoUrl);
        await storageRef.delete();
      } catch (e) {
        debugPrint('Error deleting photo from storage: $e');
      }

      _photos.removeWhere((photo) => photo.id == photoId);
      _allPhotos.removeWhere((photo) => photo.id == photoId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting photo: $e');
      throw Exception('Failed to delete photo: $e');
    }
  }

  Future<void> updatePhotoCaption(String photoId, String newCaption) async {
    try {
      await _firestore.collection('photos').doc(photoId).update({
        'caption': newCaption,
      });

      final index = _photos.indexWhere((photo) => photo.id == photoId);
      if (index != -1) {
        _photos[index] = _photos[index].copyWith(caption: newCaption);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating photo caption: $e');
      throw Exception('Failed to update photo: $e');
    }
  }
}
