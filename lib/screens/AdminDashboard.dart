import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
            'Admin Dashboard',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage all sites and team members',
            style: TextStyle(fontSize: 14, color: kSubText),
          ),
          const SizedBox(height: 32),

          // Stats Section
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _statCard(Icons.business, '12', 'Total Sites'),
              _statCard(Icons.people, '24', 'Team Members'),
              _statCard(Icons.assignment, '18', 'Active Projects'),
              _statCard(Icons.check_circle, '8', 'Completed'),
            ],
          ),
          const SizedBox(height: 40),

          // Users Section
          Text(
            'Team Members',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          _buildTeamMembersList(),
          const SizedBox(height: 40),

          // Recent Sites Section
          Text(
            'Recent Sites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentSitesList(),
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
            offset: const Offset(0, 2),
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
                  fontSize: 24,
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

  Widget _buildTeamMembersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role',
              whereIn: ['admin', 'executive', 'engineer', 'worker']).snapshots(),
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
              child: Text('No team members yet',
                  style: TextStyle(color: kSubText)),
            ),
          );
        }

        final users = snapshot.data!.docs;
        return Container(
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['displayName'] ?? userData['email'] ?? 'User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kText,
                            ),
                          ),
                          Text(
                            userData['email'] ?? '',
                            style:
                                TextStyle(fontSize: 12, color: kSubText),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(userData['role'])
                            .withAlpha((0.12 * 255).round()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        userData['role'] ?? 'client',
                        style: TextStyle(
                          color: _getRoleColor(userData['role']),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentSitesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sites')
          .limit(5)
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
              child: Text('No sites yet', style: TextStyle(color: kSubText)),
            ),
          );
        }

        final sites = snapshot.data!.docs;
        return Container(
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final siteData = sites[index].data() as Map<String, dynamic>;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          Text(
                            siteData['location'] ?? 'N/A',
                            style:
                                TextStyle(fontSize: 12, color: kSubText),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kAccent.withAlpha((0.12 * 255).round()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        siteData['progress'] ?? '0%',
                        style: TextStyle(
                          color: kAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'executive':
      case 'engineer':
      case 'worker':
        return Colors.blue;
      case 'client':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
