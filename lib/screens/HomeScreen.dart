import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'AdminDashboard.dart';
import 'ClientDashboard.dart';
import 'ExecutiveDashboard.dart';
import 'AddSiteScreen.dart';
import 'LoginScreen.dart';
import 'SiteDetailsScreen.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';
import '../providers/PhotoProvider.dart';
import '../providers/ReportProvider.dart';
import '../models/SiteModel.dart';
import '../services/AuthService.dart';
import 'MySitesScreen.dart';
import 'PhotosScreen.dart';
import 'ReportsScreen.dart';
import 'SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool _isReady = false;

  Color get kBg => Theme.of(context).scaffoldBackgroundColor;
  Color get kCardBg => Theme.of(context).cardColor;
  Color get kText =>
      Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF37353E);
  Color get kSubText => Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black54;
  Color get kDark => const Color(0xFF37353E);
  Color get kAccent => const Color(0xFF715A5A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roleProvider = Provider.of<RoleProvider>(context, listen: false);
      final siteProvider = Provider.of<SiteProvider>(context, listen: false);
      final reportProvider = Provider.of<ReportProvider>(
        context,
        listen: false,
      );
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      _initializeData(
        roleProvider,
        siteProvider,
        reportProvider,
        photoProvider,
      );
    });
  }

  Future<void> _initializeData(
    RoleProvider roleProvider,
    SiteProvider siteProvider,
    ReportProvider reportProvider,
    PhotoProvider photoProvider,
  ) async {
    await roleProvider.fetchUserRole();
    await siteProvider.fetchSites(role: roleProvider.role);
    await reportProvider.fetchAllReports();
    await photoProvider.fetchAllPhotos();
    if (!mounted) return;
    setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final roleProvider = Provider.of<RoleProvider>(context);

    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "ConstructEye",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: kAccent,
                child: Text(
                  (FirebaseAuth.instance.currentUser?.email ?? 'U')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(backgroundColor: kDark, child: _sidebarContent()),
        body: getSelectedScreen(),
        floatingActionButton: roleProvider.isAdmin
            ? _buildAddSiteButton()
            : null,
      );
    }

    // Desktop — persistent sidebar
    return Scaffold(
      body: Row(
        children: [
          Container(width: 260, color: kDark, child: _sidebarContent()),
          Expanded(child: getSelectedScreen()),
        ],
      ),
      floatingActionButton: roleProvider.isAdmin
          ? _buildAddSiteButton()
          : null,
    );
  }

  // ================= SIDEBAR CONTENT =================

  Widget _sidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.construction, color: kAccent, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "ConstructEye",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _sidebarItem(Icons.dashboard, "Dashboard", 0),
        _sidebarItem(Icons.business, "My Sites", 1),
        _sidebarItem(Icons.description, "Reports", 2),
        _sidebarItem(Icons.photo, "Photos", 3),
        _sidebarItem(Icons.notifications, "Notifications", 4),
        _sidebarItem(Icons.settings, "Settings", 5),
        const Spacer(),
        _sidebarItem(Icons.logout, "Sign Out", 6),
        const SizedBox(height: 24),
      ],
    );
  }

  // ================= SIDEBAR ITEM =================

  Widget _sidebarItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        final navigator = Navigator.of(context);
        final isSmallScreen = MediaQuery.of(context).size.width < 768;
        if (index == 6) {
          await AuthService().logout();
          if (!mounted) return;
          if (isSmallScreen) {
            navigator.pop();
          }
          navigator.pushReplacement(
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
          return;
        }

        setState(() => selectedIndex = index);
        if (isSmallScreen) {
          navigator.pop();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? kAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
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
  final roleProvider = Provider.of<RoleProvider>(context);
  
  // Show role-specific dashboard when on Dashboard tab (index 0)
  if (selectedIndex == 0) {
    if (roleProvider.isAdmin) {
      return const AdminDashboard();
    } else if (roleProvider.isExecutive) {
      return const ExecutiveDashboard();
    } else {
      return const ClientDashboard();
    }
  }

  // Keep existing screens for other tabs
  switch (selectedIndex) {
    case 0:
      return _overviewScreen();
    case 1:
      return MySitesScreen();
    case 2:
      return ReportsScreen();
    case 3:
      return PhotosScreen();
    case 4:
      return _simpleScreen("Notifications");
    case 5:
      return SettingsScreen();
    default:
      return _overviewScreen();
  }
}
  // ================= OVERVIEW =================

  Widget _overviewScreen() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final pad = isMobile ? 16.0 : 28.0;
    final siteProvider = Provider.of<SiteProvider>(context);
    final sites = siteProvider.sites;
    final reportProvider = Provider.of<ReportProvider>(context);
    final photoProvider = Provider.of<PhotoProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 36,
                          fontWeight: FontWeight.bold,
                          color: kText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Monitor construction projects",
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 15,
                          color: kSubText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: kAccent,
                    child: const Text(
                      "JD",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: isMobile ? 20 : 28),

            // Stat cards
            isMobile
                ? Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          Icons.business,
                          sites.length.toString(),
                          "Sites",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          Icons.description,
                          reportProvider.reports.length.toString(),
                          "Reports",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          Icons.camera_alt,
                          photoProvider.photos.length.toString(),
                          "Photos",
                          isMobile,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          Icons.business,
                          sites.length.toString(),
                          "Active Sites",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _statCard(
                          Icons.description,
                          reportProvider.reports.length.toString(),
                          "Reports Generated",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _statCard(
                          Icons.camera_alt,
                          photoProvider.photos.length.toString(),
                          "Photos Uploaded",
                          isMobile,
                        ),
                      ),
                    ],
                  ),

            SizedBox(height: isMobile ? 24 : 36),

            if (siteProvider.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha((0.08 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Unable to load site data: ${siteProvider.errorMessage}',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.red.shade700,
                  ),
                ),
              ),

            if (siteProvider.errorMessage != null) const SizedBox(height: 16),

            Text(
              "Recent Construction Sites",
              style: TextStyle(
                fontSize: isMobile ? 17 : 24,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
            ),

            const SizedBox(height: 16),

            // Sites — list on mobile, grid on desktop
            sites.isEmpty
                ? _emptySites()
                : isMobile
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _siteCard(sites[i], isMobile),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sites.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.95,
                        ),
                    itemBuilder: (_, i) => _siteCard(sites[i], isMobile),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _emptySites() => Container(
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Center(
      child: Text(
        "No sites yet. Add your first site!",
        style: TextStyle(
          color: kSubText.withAlpha((0.6 * 255).round()),
          fontSize: 15,
        ),
      ),
    ),
  );

  double _parseProgressValue(String progress) {
    final cleaned = progress.replaceAll('%', '').trim();
    final value = double.tryParse(cleaned);
    if (value == null) return 0.0;
    return value.clamp(0.0, 100.0) / 100.0;
  }

  Widget _simpleScreen(String title) => Center(
    child: Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kText),
    ),
  );

  // ================= STAT CARD =================

  Widget _statCard(IconData icon, String value, String title, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 22),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
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
          Icon(icon, size: isMobile ? 22 : 30, color: kAccent),
          SizedBox(height: isMobile ? 10 : 16),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 22 : 32,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: isMobile ? 11 : 14, color: kSubText),
          ),
        ],
      ),
    );
  }

  // ================= SITE CARD =================

  Widget _siteCard(SiteModel site, bool isMobile) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SiteDetailsScreen(
            title: site.title,
            location: site.location,
            progress: site.progress,
            status: site.status,
            statusColor: site.statusColor,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(20),
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
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=800&auto=format&fit=crop',
                height: isMobile ? 150 : 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(isMobile ? 14 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          site.title,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            fontWeight: FontWeight.bold,
                            color: kText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: site.statusColor.withAlpha(
                            (0.12 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          site.status,
                          style: TextStyle(
                            color: site.statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 11 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: isMobile ? 14 : 16,
                        color: kSubText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        site.location,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: kSubText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Progress",
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.w600,
                          color: kText,
                        ),
                      ),
                      Text(
                        site.progress,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: kAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _parseProgressValue(site.progress),
                      minHeight: isMobile ? 6 : 8,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey.shade200,
                      color: kAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADD SITE BUTTON =================

  Widget _buildAddSiteButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddSiteScreen()),
      ),
      backgroundColor: kAccent,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
