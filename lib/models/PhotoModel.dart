import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String id;
  final String siteId;
  final String url;
  final String caption;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String? description;

  PhotoModel({
    required this.id,
    required this.siteId,
    required this.url,
    required this.caption,
    required this.uploadedAt,
    required this.uploadedBy,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'siteId': siteId,
      'url': url,
      'caption': caption,
      'uploadedAt': uploadedAt,
      'uploadedBy': uploadedBy,
      'description': description,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime uploadedAt;
    if (map['uploadedAt'] is Timestamp) {
      uploadedAt = (map['uploadedAt'] as Timestamp).toDate();
    } else if (map['uploadedAt'] is DateTime) {
      uploadedAt = map['uploadedAt'] as DateTime;
    } else if (map['uploadedAt'] is String) {
      uploadedAt = DateTime.tryParse(map['uploadedAt'] as String) ?? DateTime.now();
    } else {
      uploadedAt = DateTime.now();
    }

    return PhotoModel(
      id: docId,
      siteId: map['siteId'] ?? '',
      url: map['url'] ?? '',
      caption: map['caption'] ?? '',
      uploadedAt: uploadedAt,
      uploadedBy: map['uploadedBy'] ?? '',
      description: map['description'] as String?,
    );
  }

  PhotoModel copyWith({
    String? id,
    String? siteId,
    String? url,
    String? caption,
    DateTime? uploadedAt,
    String? uploadedBy,
    String? description,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      description: description ?? this.description,
    );
  }
}
