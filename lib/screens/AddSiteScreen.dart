import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/SiteModel.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';
import '../services/AvailabilityService.dart';

class AddSiteScreen extends StatefulWidget {
  final SiteModel? site;

  const AddSiteScreen({super.key, this.site});

  @override
  State<AddSiteScreen> createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final statusController = TextEditingController();
  final pincodeController = TextEditingController();

  bool isLoading = false;
  bool isCheckingAvailability = false;
  String? availabilityMessage;

  @override
  void initState() {
    super.initState();
    if (widget.site != null) {
      titleController.text = widget.site!.title;
      locationController.text = widget.site!.location;
      statusController.text = widget.site!.status;
      pincodeController.text = widget.site!.pincode;
    }
  }

  Future<void> _saveSite() async {
    final title = titleController.text.trim();
    final location = locationController.text.trim();
    final status = statusController.text.trim();
    final pincode = pincodeController.text.trim();

    if (title.isEmpty ||
        location.isEmpty ||
        status.isEmpty ||
        pincode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    final normalizedProgress = widget.site?.progress ?? '0%';
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User session expired')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final available = await AvailabilityService().checkAvailability(pincode);
      if (!mounted) return;

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service unavailable in this area')),
        );

        if (!mounted) return;
        setState(() {
          isLoading = false;
        });

        return;
      }

      final site = SiteModel(
        id: widget.site?.id ?? '',
        title: title,
        location: location,
        progress: normalizedProgress,
        status: status,
        pincode: pincode,
        statusColor: widget.site?.statusColor ?? Colors.green,
        ownerId: widget.site?.ownerId ?? currentUser.uid,
      );

      final role = Provider.of<RoleProvider>(context, listen: false).role;
      if (widget.site != null) {
        await Provider.of<SiteProvider>(
          context,
          listen: false,
        ).updateSite(site, role: role);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site updated successfully')),
        );
      } else {
        await Provider.of<SiteProvider>(
          context,
          listen: false,
        ).addSite(site, role: role);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site added successfully')),
        );
      }

      if (!mounted) return;
      Navigator.pop(context, site);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkAvailability() async {
    final pincode = pincodeController.text.trim();
    if (pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a pincode to check availability')),
      );
      return;
    }

    setState(() {
      isCheckingAvailability = true;
      availabilityMessage = null;
    });

    final available = await AvailabilityService().checkAvailability(pincode);
    if (!mounted) return;

    setState(() {
      isCheckingAvailability = false;
      availabilityMessage = available
          ? 'Service is available in this area.'
          : 'Service is unavailable in this area.';
    });
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    statusController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.site != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Site' : 'Add Site')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: inputDecoration('Site Title'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: locationController,
              decoration: inputDecoration('Location'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: statusController,
              decoration: inputDecoration('Status'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Pincode'),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: isCheckingAvailability ? null : _checkAvailability,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF715A5A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isCheckingAvailability
                    ? const CircularProgressIndicator(color: Color(0xFF715A5A))
                    : const Text(
                        'Check Availability',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF715A5A),
                        ),
                      ),
              ),
            ),

            if (availabilityMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                availabilityMessage!,
                style: TextStyle(
                  color: availabilityMessage!.contains('available')
                      ? Colors.green
                      : Colors.red,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 20),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveSite,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF715A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.site != null ? 'Update Site' : 'Save Site',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
