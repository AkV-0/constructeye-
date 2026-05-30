import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExecutiveDashboard extends StatefulWidget {
  const ExecutiveDashboard({super.key});

  @override
  State<ExecutiveDashboard> createState() => _ExecutiveDashboardState();
}

class _ExecutiveDashboardState extends State<ExecutiveDashboard> {
  Color get kText =>
      Theme.of(context).textTheme.bodyLarge?.color ??
      const Color(0xFF37353E);
  Color get kSubText => Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black54;
  Color get kAccent => const Color(0xFF715A5A);
  Color get kCardBg => Theme.of(context).cardColor;

  Future<Map<String, dynamic>?> _getUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with role info
          FutureBuilder<Map<String, dynamic>?>(
            future: _getUserProfile(),
            builder: (context, snapshot) {
              final userData = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${userData?['displayName'] ?? 'Engineer'}',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: kText,
                        ),
                      ),
                      Text(
                        'Field Updates & Documentation',
                        style: TextStyle(fontSize: 14, color: kSubText),
                      ),
                    ],
                  ),
                  if (!isMobile)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Designation',
                            style: TextStyle(
                              fontSize: 12,
                              color: kSubText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData?['designation'] ?? 'Engineer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kText,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Quick Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _statCard(Icons.assignment, '5', 'Assigned Sites'),
              _statCard(Icons.photo_camera, '24', 'Photos Uploaded'),
              _statCard(Icons.check_box, '12', 'Tasks Completed'),
              _statCard(Icons.trending_up, '95%', 'Accuracy'),
            ],
          ),
          const SizedBox(height: 40),

          // Action Cards
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.2 : 1,
            children: [
              _actionCard(
                Icons.photo_camera,
                'Upload Photos',
                'Document site progress',
                Colors.blue,
                onTap: () => _showSiteSelectionDialog(),
              ),
              _actionCard(
                Icons.assignment,
                'Submit Report',
                'Daily field updates',
                Colors.green,
                onTap: () => _showComingSoon('Reports'),
              ),
              _actionCard(
                Icons.map,
                'View Sites',
                'Check assigned projects',
                Colors.orange,
                onTap: () => _showComingSoon('Site List'),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Recent Sites
          Text(
            'Assigned Sites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          _buildAssignedSitesList(),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
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

  Widget _actionCard(
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withAlpha((0.1 * 255).round()),
              color.withAlpha((0.05 * 255).round()),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withAlpha((0.2 * 255).round()),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: kText),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: kSubText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedSitesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sites')
          .limit(3)
          .snapshots(),
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
              child: Text('No sites assigned yet',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siteData['title'] ?? 'Untitled',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          siteData['location'] ?? 'Location TBD',
                          style: TextStyle(fontSize: 12, color: kSubText),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        siteData['progress'] ?? '0%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAccent,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
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
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSiteSelectionDialog() async {
    final sites = await FirebaseFirestore.instance
        .collection('sites')
        .get();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Site'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sites.docs.length,
            itemBuilder: (context, index) {
              final siteData =
                  sites.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(siteData['title'] ?? 'Untitled'),
                subtitle: Text(siteData['location'] ?? 'N/A'),
                onTap: () {
                  Navigator.pop(context);
                  // Note: You'll need to pass the site data to PhotoUploadScreen
                  _navigateToPhotoUpload(sites.docs[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToPhotoUpload(DocumentSnapshot site) {
    final siteData = site.data() as Map<String, dynamic>;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigate to photo upload for: ${siteData['title']}',
        ),
      ),
    );
    // TODO: Navigate to PhotoUploadScreen when ready
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => PhotoUploadScreen(siteId: site.id),
    //   ),
    // );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!')),
    );
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
