import 'package:flutter/material.dart';

import '../services/AvailabilityService.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final pincodeController = TextEditingController();
  bool isChecking = false;
  String? resultMessage;

  Future<void> _checkAvailability() async {
    final pincode = pincodeController.text.trim();
    if (pincode.isEmpty) {
      setState(() {
        resultMessage = 'Enter a pincode to check availability.';
      });
      return;
    }

    setState(() {
      isChecking = true;
      resultMessage = null;
    });

    try {
      final available = await AvailabilityService().checkAvailability(pincode);
      setState(() {
        resultMessage = available
            ? 'Service is available in this area.'
            : 'Service is unavailable in this area.';
      });
    } catch (error) {
      setState(() {
        resultMessage = 'Unable to verify availability. ${error.toString()}';
      });
    } finally {
      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Availability'),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check delivery and service availability by pincode.',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isChecking ? null : _checkAvailability,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF715A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isChecking
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Check Availability'),
              ),
            ),
            const SizedBox(height: 20),
            if (resultMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: resultMessage!.contains('available')
                      ? Colors.green.withAlpha((0.1 * 255).round())
                      : Colors.red.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  resultMessage!,
                  style: TextStyle(
                    fontSize: 14,
                    color: resultMessage!.contains('available')
                        ? (isDark ? Colors.green.shade400 : Colors.green.shade700)
                        : (isDark ? Colors.red.shade400 : Colors.red.shade700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
