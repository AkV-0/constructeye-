import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/RoleProvider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color kBg = isDark
        ? const Color(0xFF212121)
        : const Color(0xFFD3DAD9);

    final Color kCard = isDark ? const Color(0xFF2C2C2C) : Colors.white;

    final Color kText = isDark ? Colors.white : const Color(0xFF212121);

    final Color kSubText = isDark ? Colors.white70 : Colors.black54;

    final Color kDark = const Color(0xFF37353E);

    final Color kAccent = const Color(0xFF715A5A);

    return Scaffold(
      backgroundColor: kBg,

      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Application Settings",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: kCard,

                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: kAccent),

                    title: Text(
                      "Current Role",
                      style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      roleProvider.role.toUpperCase(),
                      style: TextStyle(color: kSubText),
                    ),
                  ),

                  Divider(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),

                  ListTile(
                    leading: Icon(Icons.dark_mode, color: kAccent),

                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      "Theme follows system settings",
                      style: TextStyle(color: kSubText),
                    ),

                    trailing: Icon(
                      isDark ? Icons.toggle_on : Icons.toggle_off,
                      color: kAccent,
                      size: 34,
                    ),
                  ),

                  Divider(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),

                  ListTile(
                    leading: Icon(Icons.notifications, color: kAccent),

                    title: Text(
                      "Notifications",
                      style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      "Manage project notifications",
                      style: TextStyle(color: kSubText),
                    ),
                  ),

                  Divider(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),

                  ListTile(
                    leading: Icon(Icons.security, color: kAccent),

                    title: Text(
                      "Privacy & Security",
                      style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      "Manage account permissions",
                      style: TextStyle(color: kSubText),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  Icon(Icons.construction, size: 48, color: kAccent),

                  const SizedBox(height: 12),

                  Text(
                    "ConstructEye",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Construction Monitoring Platform",
                    style: TextStyle(color: kSubText),
                  ),

                  const SizedBox(height: 12),

                  Text("Version 1.0.0", style: TextStyle(color: kSubText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
