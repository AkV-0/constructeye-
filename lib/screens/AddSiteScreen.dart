import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/SiteModel.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';
import '../services/AvailabilityService.dart';

class AddSiteScreen extends StatefulWidget {
  const AddSiteScreen({super.key});

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
    final normalizedProgress = '0%';
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

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service unavailable in this area')),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      final site = SiteModel(
        id: '',
        title: title,
        location: location,
        progress: normalizedProgress,
        status: status,
        pincode: pincode,
        statusColor: Colors.green,
        ownerId: currentUser.uid,
      );

      final role = Provider.of<RoleProvider>(context, listen: false).role;
      await Provider.of<SiteProvider>(
        context,
        listen: false,
      ).addSite(site, role: role);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Site added successfully')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Site'),
        backgroundColor: const Color(0xFF37353E),
      ),
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
                    : const Text(
                        'Save Site',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
