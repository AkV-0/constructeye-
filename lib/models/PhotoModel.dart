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
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'uploadedBy': uploadedBy,
      'description': description,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime uploadedAtDate;
    final timestamp = map['uploadedAt'];
    if (timestamp is Timestamp) {
      uploadedAtDate = timestamp.toDate();
    } else if (timestamp is DateTime) {
      uploadedAtDate = timestamp;
    } else if (timestamp is String) {
      uploadedAtDate = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      uploadedAtDate = DateTime.now();
    }

    return PhotoModel(
      id: docId,
      siteId: map['siteId']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      caption: map['caption']?.toString() ?? '',
      uploadedAt: uploadedAtDate,
      uploadedBy: map['uploadedBy']?.toString() ?? '',
      description: map['description']?.toString(),
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
