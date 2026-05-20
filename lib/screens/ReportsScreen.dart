import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ReportModel.dart';
import '../providers/ReportProvider.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? selectedSiteId;
  String filterStatus = 'all';

  Color get kBg => Theme.of(context).scaffoldBackgroundColor;
  Color get kCardBg => Theme.of(context).cardColor;
  Color get kText =>
      Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF37353E);
  Color get kDark => const Color(0xFF37353E);
  Color get kAccent => const Color(0xFF715A5A);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReportProvider>(context, listen: false).fetchAllReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final sites = Provider.of<SiteProvider>(context).sites;
    final roleProvider = Provider.of<RoleProvider>(context);
    final canCreate = roleProvider.isAdmin || roleProvider.isWorker;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reports",
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 36,
                          fontWeight: FontWeight.bold,
                          color: kText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create and manage project reports",
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 15,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (canCreate)
                  ElevatedButton.icon(
                    onPressed: () => _showCreateReportDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text("New Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                if (!canCreate)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Admin and Engineer roles can create reports.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String?>(
                          value: selectedSiteId,
                          hint: const Text("All Sites"),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text("All Sites"),
                            ),
                            ...sites.map((site) {
                              return DropdownMenuItem<String?>(
                                value: site.id,
                                child: Text(site.title),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedSiteId = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<String>(
                          value: filterStatus,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text("All Status"),
                            ),
                            DropdownMenuItem(
                              value: 'pending',
                              child: Text("Pending"),
                            ),
                            DropdownMenuItem(
                              value: 'in_progress',
                              child: Text("In Progress"),
                            ),
                            DropdownMenuItem(
                              value: 'completed',
                              child: Text("Completed"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              filterStatus = value ?? 'all';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reports List
            Consumer<ReportProvider>(
              builder: (context, reportProvider, _) {
                if (reportProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                var filteredReports = reportProvider.reports;

                if (selectedSiteId != null) {
                  filteredReports = filteredReports
                      .where((r) => r.siteId == selectedSiteId)
                      .toList();
                }

                if (filterStatus != 'all') {
                  filteredReports = filteredReports
                      .where((r) => r.status == filterStatus)
                      .toList();
                }

                if (filteredReports.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No reports found",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final canCreate =
                    Provider.of<RoleProvider>(context, listen: false).isAdmin ||
                    Provider.of<RoleProvider>(context, listen: false).isWorker;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredReports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = filteredReports[index];
                    return _buildReportCard(report, reportProvider, canCreate);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    ReportModel report,
    ReportProvider reportProvider,
    bool canCreate,
  ) {
    final statusColor = _getStatusColor(report.status);
    final priorityColor = _getPriorityColor(report.priority);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canCreate)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    if (report.status != 'completed')
                      PopupMenuItem(
                        child: const Text("Mark Complete"),
                        onTap: () {
                          reportProvider.updateReportStatus(
                            report.id,
                            'completed',
                          );
                        },
                      ),
                    if (report.status != 'in_progress')
                      PopupMenuItem(
                        child: const Text("In Progress"),
                        onTap: () {
                          reportProvider.updateReportStatus(
                            report.id,
                            'in_progress',
                          );
                        },
                      ),
                    PopupMenuItem(
                      child: const Text("Delete"),
                      onTap: () {
                        _showDeleteReportDialog(report, reportProvider);
                      },
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          if (report.dueDate != null) ...[
            const SizedBox(height: 8),
            Text(
              "Due: ${report.dueDate.toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showCreateReportDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final sites = Provider.of<SiteProvider>(context, listen: false).sites;
    String? selectedSite = sites.isNotEmpty ? sites.first.id : null;
    String priority = 'medium';
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Create New Report"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Report Title",
                    hintText: "Enter report title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter report details",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButton<String?>(
                  value: selectedSite,
                  isExpanded: true,
                  items: sites
                      .map(
                        (site) => DropdownMenuItem<String?>(
                          value: site.id,
                          child: Text(site.title),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSite = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: priority,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text("Low")),
                    DropdownMenuItem(value: 'medium', child: Text("Medium")),
                    DropdownMenuItem(value: 'high', child: Text("High")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      priority = value ?? 'medium';
                    });
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        dueDate = date;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: Text(
                    dueDate == null
                        ? "Set Due Date"
                        : "Due: ${dueDate.toString().split(' ')[0]}",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    selectedSite == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                try {
                  final report = ReportModel(
                    id: '',
                    siteId: selectedSite!,
                    title: titleController.text,
                    description: descriptionController.text,
                    status: 'pending',
                    createdAt: DateTime.now(),
                    dueDate: dueDate,
                    priority: priority,
                  );

                  await Provider.of<ReportProvider>(
                    context,
                    listen: false,
                  ).createReport(report);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report created successfully"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteReportDialog(
    ReportModel report,
    ReportProvider reportProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Report"),
        content: const Text("Are you sure you want to delete this report?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await reportProvider.deleteReport(report.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Report deleted successfully")),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
