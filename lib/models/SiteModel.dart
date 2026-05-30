import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SiteModel {
  final String id;
  final String title;
  final String location;
  final String progress;
  final String status;
  final String pincode;
  final Color statusColor;
  final String ownerId;
  final String? assignedTo;
  final DateTime? createdAt;

  SiteModel({
    required this.id,
    required this.title,
    required this.location,
    required this.progress,
    required this.status,
    required this.pincode,
    required this.statusColor,
    required this.ownerId,
    this.assignedTo,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'progress': normalizedProgress(progress),
      'status': status,
      'pincode': pincode,
      'statusColor': statusColor.toARGB32(),
      'ownerId': ownerId,
      'assignedTo': assignedTo,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  static String normalizedProgress(String rawProgress) {
    final cleaned = rawProgress.replaceAll('%', '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return '0%';
    final clamped = parsed.clamp(0.0, 100.0);
    return '${clamped.toStringAsFixed(clamped.truncateToDouble() == clamped ? 0 : 1)}%';
  }

  factory SiteModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime created;
    final raw = map['createdAt'];
    if (raw is Timestamp) {
      created = raw.toDate();
    } else if (raw is DateTime) {
      created = raw;
    } else {
      created = DateTime.now();
    }

    return SiteModel(
      id: docId,
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      progress: normalizedProgress(map['progress']?.toString() ?? ''),
      status: map['status'] ?? '',
      pincode: map['pincode'] ?? '',
      statusColor: Color(map['statusColor'] ?? 0xFF4CAF50),
      ownerId: map['ownerId'] ?? '',
      assignedTo: map['assignedTo'],
      createdAt: created,
    );
  }
}
