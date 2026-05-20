import 'package:flutter/material.dart';

import '../models/SiteModel.dart';
import '../services/SiteService.dart';

class SiteProvider extends ChangeNotifier {
  final SiteService _siteService = SiteService();

  List<SiteModel> _sites = [];

  bool _isLoading = false;

  List<SiteModel> get sites => _sites;
  bool get isLoading => _isLoading;

  Future<void> fetchSites({required String role}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (role == 'admin') {
        _sites = await _siteService.fetchAllSites();
      } else if (role == 'worker' || role == 'engineer') {
        _sites = await _siteService.fetchAssignedSites(_siteService.userId);
      } else {
        _sites = await _siteService.fetchUserSites();
      }
    } catch (e) {
      debugPrint(e.toString());
      _sites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSite(SiteModel site, {required String role}) async {
    await _siteService.addSite(site);
    await fetchSites(role: role);
  }

  Future<void> removeSite(SiteModel site, {required String role}) async {
    await _siteService.deleteSite(site);
    await fetchSites(role: role);
  }

  Future<void> updateSite(SiteModel site, {required String role}) async {
    await _siteService.updateSite(site);
    await fetchSites(role: role);
  }
}
