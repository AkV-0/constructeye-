import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddSiteScreen.dart';
import '../providers/RoleProvider.dart';
import '../providers/SiteProvider.dart';
import 'SiteDetailsScreen.dart';

class MySitesScreen extends StatefulWidget {
  const MySitesScreen({super.key});

  @override
  State<MySitesScreen> createState() => _MySitesScreenState();
}

class _MySitesScreenState extends State<MySitesScreen> {
  @override
  void initState() {
    super.initState();

    final role = Provider.of<RoleProvider>(context, listen: false).role;
    final siteProvider = Provider.of<SiteProvider>(context, listen: false);
    Future.microtask(() async {
      await siteProvider.fetchSites(role: role);
      if (!mounted) return;
    });
  }

  Future<void> _refresh() async {
    final role = Provider.of<RoleProvider>(context, listen: false).role;
    await Provider.of<SiteProvider>(
      context,
      listen: false,
    ).fetchSites(role: role);
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final roleProvider = Provider.of<RoleProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sites'),
        actions: [
          if (!roleProvider.isWorker)
            IconButton(
              tooltip: 'Add Site',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddSiteScreen()),
                );
                await _refresh();
              },
            ),
        ],
      ),
      body: siteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : siteProvider.errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Error loading sites: ${siteProvider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            )
          : siteProvider.sites.isEmpty
          ? const Center(
              child: Text('No sites added yet', style: TextStyle(fontSize: 16)),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: siteProvider.sites.length,
                itemBuilder: (context, index) {
                  final site = siteProvider.sites[index];
                  final canDelete =
                      roleProvider.isAdmin ||
                      (roleProvider.isUser && site.ownerId == currentUserId);

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        site.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: ${site.location}'),
                            Text('Progress: ${site.progress}'),
                            Text('Status: ${site.status}'),
                            Text('Pincode: ${site.pincode}'),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (roleProvider.isAdmin ||
                              (roleProvider.isUser &&
                                  site.ownerId == currentUserId))
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueGrey,
                              ),
                              tooltip: 'Edit Site',
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddSiteScreen(site: site),
                                  ),
                                );
                                await _refresh();
                              },
                            ),
                          if (canDelete)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete Site'),
                                      content: const Text(
                                        'Are you sure you want to delete this site?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await siteProvider.removeSite(
                                    site,
                                    role: roleProvider.role,
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SiteDetailsScreen(site: site),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
