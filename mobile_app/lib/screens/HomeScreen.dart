import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// removed unused import: SiteDetailsScreen.dart
import '../providers/SiteProvider.dart';
import '../models/SiteModel.dart';

import 'MySitesScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F5),

      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 280,
            color: const Color(0xFF37353E),

            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  "ConstructEye",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                sidebarItem(Icons.dashboard, "Dashboard", 0),

                sidebarItem(Icons.business, "My Sites", 1),

                sidebarItem(Icons.description, "Reports", 2),

                sidebarItem(Icons.photo, "Photos", 3),

                sidebarItem(Icons.notifications, "Notifications", 4),

                sidebarItem(Icons.settings, "Settings", 5),

                const Spacer(),

                sidebarItem(Icons.logout, "Sign Out", 6),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // ================= MAIN CONTENT =================
          Expanded(child: getSelectedScreen()),
        ],
      ),
    );
  }

  // ================= SIDEBAR ITEM =================

  Widget sidebarItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF715A5A) : Colors.transparent,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),

            const SizedBox(width: 18),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SCREEN SWITCHER =================

  Widget getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return overviewScreen();

      case 1:
        return MySitesScreen();

      case 2:
        return simpleScreen("Reports");

      case 3:
        return simpleScreen("Photos");

      case 4:
        return simpleScreen("Notifications");

      case 5:
        return simpleScreen("Settings");

      default:
        return overviewScreen();
    }
  }

  // ================= OVERVIEW SCREEN =================

  Widget overviewScreen() {
    final siteProvider = Provider.of<SiteProvider>(context);

    final List<SiteModel> sites = siteProvider.sites;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37353E),
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Monitor construction projects",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ],
                ),

                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF715A5A),

                  child: Text(
                    "JD",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ================= STATS =================
            Row(
              children: [
                Expanded(
                  child: statCard(
                    Icons.business,
                    sites.length.toString(),
                    "Active Sites",
                  ),
                ),

                const SizedBox(width: 24),

                Expanded(child: statCard(Icons.description, "24", "Reports")),

                const SizedBox(width: 24),

                Expanded(child: statCard(Icons.camera_alt, "842", "Photos")),
              ],
            ),

            const SizedBox(height: 50),

            const Text(
              "Recent Construction Sites",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37353E),
              ),
            ),

            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: sites.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.35,
              ),

              itemBuilder: (context, index) {
                final site = sites[index];

                return siteGridCard(
                  site.title,
                  site.location,
                  site.progress,
                  site.status,
                  site.statusColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= SIMPLE SCREEN =================

  Widget simpleScreen(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= STAT CARD =================

  Widget statCard(IconData icon, String value, String title) {
    return Container(
      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, size: 34, color: const Color(0xFF715A5A)),

          const SizedBox(height: 24),

          Text(
            value,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37353E),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ================= SITE CARD =================

  Widget siteGridCard(
    String title,
    String location,
    String progress,
    String status,
    Color statusColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),

            child: Image.network(
              'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=1200&auto=format&fit=crop',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(22),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF37353E),
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: statusColor.withAlpha((0.12 * 255).round()),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Progress",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        progress,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF715A5A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: double.parse(progress.replaceAll("%", "")) / 100,

                      minHeight: 10,

                      backgroundColor: Colors.grey.shade200,

                      color: const Color(0xFF715A5A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
