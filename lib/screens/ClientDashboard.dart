import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  Color get kText =>
      Theme.of(context).textTheme.bodyLarge?.color ??
      const Color(0xFF37353E);
  Color get kSubText => Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black54;
  Color get kAccent => const Color(0xFF715A5A);
  Color get kCardBg => Theme.of(context).cardColor;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'My Projects',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track progress and view project updates',
            style: TextStyle(fontSize: 14, color: kSubText),
          ),
          const SizedBox(height: 32),

          // Progress Overview
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _statCard(Icons.business, '0', 'Projects'),
              _statCard(Icons.photo_library, '0', 'Photos'),
              _statCard(Icons.check_circle, '0', 'Completed'),
            ],
          ),
          const SizedBox(height: 40),

          // Projects List
          Text(
            'Your Projects',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          _buildProjectsList(),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 28, color: kAccent),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: kText),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 11, color: kSubText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sites').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kCardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('No projects assigned yet',
                  style: TextStyle(color: kSubText)),
            ),
          );
        }

        final sites = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sites.length,
          itemBuilder: (context, index) {
            final siteData = sites[index].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          siteData['title'] ?? 'Untitled',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kText,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(siteData['status'])
                              .withAlpha((0.12 * 255).round()),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          siteData['status'] ?? 'Pending',
                          style: TextStyle(
                            color: _getStatusColor(siteData['status']),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    siteData['location'] ?? 'Location TBD',
                    style: TextStyle(color: kSubText, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(fontSize: 12, color: kSubText),
                      ),
                      Text(
                        siteData['progress'] ?? '0%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _parseProgress(siteData['progress'] ?? '0%'),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: kAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  double _parseProgress(String progress) {
    final cleaned = progress.replaceAll('%', '').trim();
    final value = double.tryParse(cleaned);
    return (value ?? 0.0).clamp(0.0, 100.0) / 100.0;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'on hold':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey;
    }
  }
}
