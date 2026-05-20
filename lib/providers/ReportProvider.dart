import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ReportModel.dart';

class ReportProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ReportModel> _reports = [];
  bool _isLoading = false;

  List<ReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  Future<void> fetchReportsBySite(String siteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('reports')
          .where('siteId', isEqualTo: siteId)
          .orderBy('createdAt', descending: true)
          .get();

      _reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .get();

      _reports = snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> createReport(ReportModel report) async {
    try {
      final docRef = await _firestore.collection('reports').add(report.toMap());
      await fetchAllReports();
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating report: $e');
      throw Exception('Failed to create report: $e');
    }
  }

  Future<void> updateReport(String reportId, ReportModel report) async {
    try {
      await _firestore
          .collection('reports')
          .doc(reportId)
          .update(report.toMap());
      await fetchAllReports();
    } catch (e) {
      debugPrint('Error updating report: $e');
      throw Exception('Failed to update report: $e');
    }
  }

  Future<void> updateReportStatus(String reportId, String newStatus) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': newStatus,
      });

      final index = _reports.indexWhere((report) => report.id == reportId);
      if (index != -1) {
        _reports[index] = _reports[index].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating report status: $e');
      throw Exception('Failed to update report: $e');
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).delete();
      _reports.removeWhere((report) => report.id == reportId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting report: $e');
      throw Exception('Failed to delete report: $e');
    }
  }
}
