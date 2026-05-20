import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String siteId;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String priority;
  final String? assignedTo;
  final List<String>? attachments;

  ReportModel({
    required this.id,
    required this.siteId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.dueDate,
    required this.priority,
    this.assignedTo,
    this.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'siteId': siteId,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'priority': priority,
      'assignedTo': assignedTo,
      'attachments': attachments ?? [],
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReportModel(
      id: docId,
      siteId: map['siteId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      priority: map['priority'] ?? 'medium',
      assignedTo: map['assignedTo'],
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }

  ReportModel copyWith({
    String? id,
    String? siteId,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
    String? assignedTo,
    List<String>? attachments,
  }) {
    return ReportModel(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      attachments: attachments ?? this.attachments,
    );
  }
}
