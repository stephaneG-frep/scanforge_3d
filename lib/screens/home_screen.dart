import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_provider.dart';
import '../widgets/scan_card.dart';
import 'capture_screen.dart';
import 'guide_screen.dart';
import 'scan_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('ScanForge 3D')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Demarrer un nouveau projet de scan'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final project = await context.read<ScanProvider>().createProject();
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CaptureScreen(projectId: project.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Nouveau scan'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Guide pour reussir un scan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GuideScreen()),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Scans'),
                        Text('${provider.scanCount}', style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Exports'),
                        Text('${provider.exportsCount}', style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Anciens scans', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (provider.projects.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Aucun scan pour le moment.'),
              ),
            )
          else
            ...provider.projects.map(
              (p) => ScanCard(
                project: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScanDetailScreen(projectId: p.id)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
