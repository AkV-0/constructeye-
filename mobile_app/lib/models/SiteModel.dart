import 'package:flutter/material.dart';

class SiteModel {
  final String title;
  final String location;
  final String progress;
  final String status;
  final Color statusColor;

  SiteModel({
    required this.title,
    required this.location,
    required this.progress,
    required this.status,
    required this.statusColor,
  });
}
