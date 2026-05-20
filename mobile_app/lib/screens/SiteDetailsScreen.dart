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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF37353E),

        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),

              child: Image.network(
                'https://images.unsplash.com/photo-1504307651254-35680f356dfd?q=80&w=1200&auto=format&fit=crop',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37353E),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),

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

            const SizedBox(height: 18),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),

                const SizedBox(width: 8),

                Text(
                  location,
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              "Project Progress",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37353E),
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: LinearProgressIndicator(
                value: double.parse(progress.replaceAll("%", "")) / 100,

                minHeight: 18,

                backgroundColor: Colors.grey.shade300,

                color: statusColor,
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,

              child: Text(
                progress,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF715A5A),
                ),
              ),
            ),

            const SizedBox(height: 50),

            Row(
              children: [
                Expanded(child: infoCard(Icons.groups, "42", "Workers")),

                const SizedBox(width: 24),

                Expanded(child: infoCard(Icons.photo_camera, "182", "Photos")),

                const SizedBox(width: 24),

                Expanded(child: infoCard(Icons.description, "24", "Reports")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(IconData icon, String value, String title) {
    return Container(
      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(icon, size: 38, color: const Color(0xFF715A5A)),

          const SizedBox(height: 20),

          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37353E),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
