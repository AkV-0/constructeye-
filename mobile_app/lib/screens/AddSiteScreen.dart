import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/SiteModel.dart';
import '../providers/SiteProvider.dart';

class AddSiteScreen extends StatefulWidget {
  @override
  State<AddSiteScreen> createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController progressController = TextEditingController();

  final TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF37353E),

        title: const Text(
          "Add Construction Site",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 550,

            padding: const EdgeInsets.all(40),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),

                  blurRadius: 16,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Create New Site",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37353E),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Add a new construction project",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                buildField("Site Name", titleController),

                const SizedBox(height: 24),

                buildField("Location", locationController),

                const SizedBox(height: 24),

                buildField("Progress %", progressController),

                const SizedBox(height: 24),

                buildField("Status", statusController),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF44444E),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      final newSite = SiteModel(
                        title: titleController.text,

                        location: locationController.text,

                        progress: "${progressController.text}%",

                        status: statusController.text,

                        statusColor: Colors.green,
                      );

                      Provider.of<SiteProvider>(
                        context,
                        listen: false,
                      ).addSite(newSite);

                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Save Site",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F8F8),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
