import 'package:flutter/material.dart';

import '../models/SiteModel.dart';

class SiteProvider extends ChangeNotifier {
  final List<SiteModel> _sites = [
    SiteModel(
      title: "Downtown Office Complex",
      location: "New York, NY",
      progress: "75%",
      status: "On Track",
      statusColor: Colors.green,
    ),

    SiteModel(
      title: "Riverside Apartments",
      location: "Chicago, IL",
      progress: "48%",
      status: "Delayed",
      statusColor: Colors.red,
    ),
  ];

  List<SiteModel> get sites => _sites;

  void addSite(SiteModel site) {
    _sites.add(site);
    notifyListeners();
  }

  void removeSite(int index) {
    _sites.removeAt(index);
    notifyListeners();
  }
}
