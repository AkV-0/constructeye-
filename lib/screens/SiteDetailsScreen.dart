import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/SiteModel.dart';
import 'AddSiteScreen.dart';

class SiteDetailsScreen extends StatefulWidget {
  final SiteModel site;

  const SiteDetailsScreen({super.key, required this.site});

  @override
  State<SiteDetailsScreen> createState() => _SiteDetailsScreenState();
}

class _SiteDetailsScreenState extends State<SiteDetailsScreen> {
  late SiteModel _site;
  Future<SiteMetrics>? _metricsFuture;

  @override
  void initState() {
    super.initState();
    _site = widget.site;
    _metricsFuture = _fetchSiteMetrics();
  }

  Future<SiteMetrics> _fetchSiteMetrics() async {
    final firestore = FirebaseFirestore.instance;

    final photosQuery = firestore
        .collection('photos')
        .where('siteId', isEqualTo: _site.id)
        .get();

    final reportsQuery = firestore
        .collection('reports')
        .where('siteId', isEqualTo: _site.id)
        .get();

    final results = await Future.wait([photosQuery, reportsQuery]);

    final photosCount = results[0].docs.length;
    final reportsCount = results[1].docs.length;
    final workersCount = _site.assignedTo?.isNotEmpty == true ? 1 : 0;

    return SiteMetrics(
      photos: photosCount,
      reports: reportsCount,
      workers: workersCount,
    );
  }

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
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _site.title,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit site',
            onPressed: () async {
              final updatedSite = await Navigator.push<SiteModel?>(
                context,
                MaterialPageRoute(builder: (_) => AddSiteScreen(site: _site)),
              );
              if (!mounted) return;
              if (updatedSite != null) {
                _site = updatedSite;
              }
              setState(() {
                _metricsFuture = _fetchSiteMetrics();
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic to quickly upload a photo for this specific site
          _showQuickUploadOptions(context);
        },
        backgroundColor: kAccent,
        icon: const Icon(Icons.add_a_photo, color: Colors.white),
        label: const Text("Upload Photo", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<SiteMetrics>(
        future: _metricsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load site details. ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }

          final metrics =
              snapshot.data ?? SiteMetrics(photos: 0, reports: 0, workers: 0);

          return SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _site.title,
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
                        color: _site.statusColor.withAlpha(
                          (0.12 * 255).round(),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _site.status,
                        style: TextStyle(
                          color: _site.statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: isDark ? Colors.white70 : Colors.grey,
                      size: isMobile ? 16 : 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _site.location,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: kSubText,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 28 : 36),

                Text(
                  'Project Progress',
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
                    value: _parseProgressValue(_site.progress),
                    minHeight: isMobile ? 12 : 16,
                    backgroundColor: Colors.grey.shade300,
                    color: _site.statusColor,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _site.progress,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: kAccent,
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 28 : 40),

                isMobile
                    ? Column(
                        children: [
                          _infoCard(
                            context,
                            Icons.groups,
                            metrics.workers.toString(),
                            'Workers',
                            isMobile,
                          ),
                          const SizedBox(height: 14),
                          _infoCard(
                            context,
                            Icons.photo_camera,
                            metrics.photos.toString(),
                            'Photos',
                            isMobile,
                          ),
                          const SizedBox(height: 14),
                          _infoCard(
                            context,
                            Icons.description,
                            metrics.reports.toString(),
                            'Reports',
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
                              metrics.workers.toString(),
                              'Workers',
                              isMobile,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _infoCard(
                              context,
                              Icons.photo_camera,
                              metrics.photos.toString(),
                              'Photos',
                              isMobile,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _infoCard(
                              context,
                              Icons.description,
                              metrics.reports.toString(),
                              'Reports',
                              isMobile,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _parseProgressValue(String progress) {
    final cleaned = progress.replaceAll('%', '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return 0.0;
    return parsed.clamp(0.0, 100.0) / 100.0;
  }

  void _showQuickUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Upload Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(context, 'camera');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("From Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(context, 'gallery');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context, String source) async {
    final picker = ImagePicker();
    try {
      final XFile? file = source == 'camera'
          ? await picker.pickImage(source: ImageSource.camera, imageQuality: 70)
          : await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

      if (file != null) {
        if (!mounted) return;
        _showUploadDialog(context, file);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  void _showUploadDialog(BuildContext context, XFile file) {
    final captionController = TextEditingController();
    bool isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Upload Photo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(file.path), height: 120, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: captionController,
                enabled: !isUploading,
                decoration: const InputDecoration(
                  labelText: "Caption",
                  border: OutlineInputBorder(),
                ),
              ),
              if (isUploading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isUploading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      if (captionController.text.isEmpty) return;
                      setDialogState(() => isUploading = true);
                      try {
                        await Provider.of<PhotoProvider>(context, listen: false)
                            .uploadPhoto(
                          _site.id,
                          file.path,
                          captionController.text,
                        );
                        if (!mounted) return;
                        Navigator.pop(context);
                        setState(() {
                          _metricsFuture = _fetchSiteMetrics();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Photo uploaded!")),
                        );
                      } catch (e) {
                        setDialogState(() => isUploading = false);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Upload failed: $e")),
                        );
                      }
                    },
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
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

class SiteMetrics {
  final int photos;
  final int reports;
  final int workers;

  SiteMetrics({
    required this.photos,
    required this.reports,
    required this.workers,
  });
}
