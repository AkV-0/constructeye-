import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ReportProvider.dart';
import '../providers/RoleProvider.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportsProvider = Provider.of<ReportProvider>(context);
    final roleProvider = Provider.of<RoleProvider>(context);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color kBg = isDark
        ? const Color(0xFF212121)
        : const Color(0xFFD3DAD9);

    final Color kCard = isDark ? const Color(0xFF2C2C2C) : Colors.white;

    final Color kText = isDark ? Colors.white : const Color(0xFF212121);

    final Color kDark = const Color(0xFF37353E);

    final Color kAccent = const Color(0xFF715A5A);

    return Scaffold(
      backgroundColor: kBg,

      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
      ),

      floatingActionButton:
          roleProvider.isAdmin || roleProvider.isExecutive
          ? FloatingActionButton(
              backgroundColor: kAccent,
              child: const Icon(Icons.add),
              onPressed: () {
                _showAddReportDialog(context, isDark);
              },
            )
          : null,

      body: reportsProvider.reports.isEmpty
          ? Center(
              child: Text(
                "No reports available",
                style: TextStyle(fontSize: 18, color: kText),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reportsProvider.reports.length,

              itemBuilder: (context, index) {
                final report = reportsProvider.reports[index];

                return Card(
                  elevation: 5,
                  color: kCard,

                  margin: const EdgeInsets.only(bottom: 16),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          report.title,

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kText,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          report.description,

                          style: TextStyle(
                            fontSize: 16,
                            color: kText.withOpacity(0.85),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: kAccent.withOpacity(0.15),

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            children: [
                              Icon(Icons.engineering, color: kAccent, size: 20),

                              const SizedBox(width: 8),

                              Text(
                                "Field Engineer Report",

                                style: TextStyle(
                                  color: kAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Icon(Icons.access_time, size: 18, color: kAccent),

                            const SizedBox(width: 6),

                            Text(
                              "Recent Update",

                              style: TextStyle(color: kText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddReportDialog(BuildContext context, bool isDark) {
    final titleController = TextEditingController();

    final descriptionController = TextEditingController();

    final Color kBg = isDark ? const Color(0xFF212121) : Colors.white;

    final Color kText = isDark ? Colors.white : const Color(0xFF212121);

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          backgroundColor: kBg,

          title: Text("Add Report", style: TextStyle(color: kText)),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: titleController,

                style: TextStyle(color: kText),

                decoration: InputDecoration(
                  labelText: "Report Title",
                  labelStyle: TextStyle(color: kText),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                maxLines: 4,

                style: TextStyle(color: kText),

                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: kText),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
