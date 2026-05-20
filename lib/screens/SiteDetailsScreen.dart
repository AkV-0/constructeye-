import 'package:flutter/material.dart';

class SiteDetailsScreen extends StatelessWidget {
  final String title;
  final String location;
  final String progress;
  final String status;
  final Color statusColor;

  const SiteDetailsScreen({
    super.key,
    required this.title,
    required this.location,
    required this.progress,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final pad = isMobile ? 16.0 : 28.0;
    final imgH = isMobile ? 200.0 : 320.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kText = isDark ? Colors.white : const Color(0xFF37353E);
    final kSubText = isDark ? Colors.white70 : Colors.black54;
    const kDark = Color(0xFF37353E);
    const kAccent = Color(0xFF715A5A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=1200&auto=format&fit=crop',
                height: imgH,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: isMobile ? 20 : 28),

            // Title + status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 34,
                      fontWeight: FontWeight.bold,
                      color: kText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isDark ? Colors.white70 : Colors.grey,
                  size: isMobile ? 16 : 18,
                ),
                const SizedBox(width: 6),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: kSubText,
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 28 : 36),

            // Progress section
            Text(
              "Project Progress",
              style: TextStyle(
                fontSize: isMobile ? 17 : 22,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LinearProgressIndicator(
                value: _parseProgressValue(progress),
                minHeight: isMobile ? 12 : 16,
                backgroundColor: Colors.grey.shade300,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                progress,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: kAccent,
                ),
              ),
            ),

            SizedBox(height: isMobile ? 28 : 40),

            // Info cards — row on desktop, column on mobile
            isMobile
                ? Column(
                    children: [
                      _infoCard(
                        context,
                        Icons.groups,
                        "42",
                        "Workers",
                        isMobile,
                      ),
                      const SizedBox(height: 14),
                      _infoCard(
                        context,
                        Icons.photo_camera,
                        "182",
                        "Photos",
                        isMobile,
                      ),
                      const SizedBox(height: 14),
                      _infoCard(
                        context,
                        Icons.description,
                        "24",
                        "Reports",
                        isMobile,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          context,
                          Icons.groups,
                          "42",
                          "Workers",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _infoCard(
                          context,
                          Icons.photo_camera,
                          "182",
                          "Photos",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _infoCard(
                          context,
                          Icons.description,
                          "24",
                          "Reports",
                          isMobile,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  double _parseProgressValue(String progress) {
    final cleaned = progress.replaceAll('%', '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return 0.0;
    return parsed.clamp(0.0, 100.0) / 100.0;
  }

  Widget _infoCard(
    BuildContext context,
    IconData icon,
    String value,
    String title,
    bool isMobile,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kCardBg = Theme.of(context).cardColor;
    final kText =
        Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF37353E);
    final kSubText = isDark ? Colors.white70 : Colors.black54;
    const kAccent = Color(0xFF715A5A);

    return Container(
      // On mobile, full-width horizontal card; on desktop, square-ish card
      padding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
          : const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isMobile
          // Horizontal layout on mobile
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kAccent.withAlpha((0.10 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: kAccent),
                ),
                const SizedBox(width: 16),
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
                      style: TextStyle(fontSize: 13, color: kSubText),
                    ),
                  ],
                ),
              ],
            )
          // Vertical layout on desktop
          : Column(
              children: [
                Icon(icon, size: 34, color: kAccent),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(title, style: TextStyle(fontSize: 15, color: kSubText)),
              ],
            ),
    );
  }
}
