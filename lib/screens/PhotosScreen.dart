import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/SiteModel.dart';
import '../providers/PhotoProvider.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';

class PhotosScreen extends StatefulWidget {
  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? selectedSiteId;

  Color get kBg => Theme.of(context).scaffoldBackgroundColor;
  Color get kCardBg => Theme.of(context).cardColor;
  Color get kText =>
      Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF37353E);
  Color get kDark => const Color(0xFF37353E);
  Color get kAccent => const Color(0xFF715A5A);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final sites = Provider.of<SiteProvider>(context).sites;
    final roleProvider = Provider.of<RoleProvider>(context);
    final canManagePhotos = roleProvider.isAdmin || roleProvider.isWorker;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Photos",
              style: TextStyle(
                fontSize: isMobile ? 24 : 36,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage site photos and documentation",
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Site Selection
            if (sites.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select a Site",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<String>(
                      value: selectedSiteId,
                      dropdownColor: kCardBg,
                      style: TextStyle(color: kText),
                      hint: Text("Choose a site to view/upload photos", style: TextStyle(color: kText.withOpacity(0.6))),
                      isExpanded: true,
                      items: sites.map((site) {
                        return DropdownMenuItem(
                          value: site.id,
                          child: Text(site.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSiteId = value;
                        });
                        if (value != null) {
                          Provider.of<PhotoProvider>(
                            context,
                            listen: false,
                          ).fetchPhotosBySite(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Upload Photo Section
            if (selectedSiteId != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Photo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (canManagePhotos)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickAndUploadPhoto('camera'),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Take Photo"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickAndUploadPhoto('gallery'),
                              icon: const Icon(Icons.image),
                              label: const Text("From Gallery"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Photo upload is available to Admin and Worker roles only.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "You can still view photos for the selected site.",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Photos List
            if (selectedSiteId != null)
              Consumer<PhotoProvider>(
                builder: (context, photoProvider, _) {
                  if (photoProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (photoProvider.photos.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No photos yet",
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: photoProvider.photos.length,
                    itemBuilder: (context, index) {
                      final photo = photoProvider.photos[index];
                      return _buildPhotoCard(
                        photo,
                        photoProvider,
                        canManagePhotos,
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(
    photo,
    PhotoProvider photoProvider,
    bool canManagePhotos,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              photo.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          // Overlay with actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    photo.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          photo.uploadedAt.toString().split('.')[0],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (canManagePhotos)
                        GestureDetector(
                          onTap: () {
                            _showDeleteDialog(photo, photoProvider);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickAndUploadPhoto(String source) async {
    try {
      final XFile? pickedFile = source == 'camera'
          ? await _imagePicker.pickImage(
              source: ImageSource.camera,
              imageQuality: 70,
              maxWidth: 1200,
            )
          : await _imagePicker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 70,
              maxWidth: 1200,
            );

      if (pickedFile != null && selectedSiteId != null) {
        if (!mounted) return;
        _showUploadDialog(pickedFile);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showUploadDialog(XFile pickedFile) {
    final captionController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Add Photo Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(pickedFile.path),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: captionController,
                  enabled: !isUploading,
                  decoration: InputDecoration(
                    labelText: "Caption",
                    hintText: "Enter a caption for this photo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  enabled: !isUploading,
                  decoration: InputDecoration(
                    labelText: "Description (Optional)",
                    hintText: "Enter additional details",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                if (isUploading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text("Uploading photo..."),
                ],
              ],
            ),
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
                      if (captionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a caption")),
                        );
                        return;
                      }

                      setDialogState(() => isUploading = true);

                      try {
                        await Provider.of<PhotoProvider>(
                          context,
                          listen: false,
                        ).uploadPhoto(
                          selectedSiteId!,
                          pickedFile.path,
                          captionController.text,
                          description: descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                        );

                        if (!mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Photo uploaded successfully")),
                        );
                      } catch (e) {
                        setDialogState(() => isUploading = false);
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(photo, PhotoProvider photoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Photo"),
        content: const Text("Are you sure you want to delete this photo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await photoProvider.deletePhoto(photo.id, photo.url);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Photo deleted successfully")),
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
