import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/scan_provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/scan_card.dart';
import 'capture_screen.dart';
import 'guide_screen.dart';
import 'scan_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanProvider>();

    return GradientScaffold(
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
                      final navigator = Navigator.of(context);
                      final provider = context.read<ScanProvider>();
                      await HapticFeedback.lightImpact();
                      final project = await provider.createProject();
                      if (!context.mounted) return;
                      navigator.push(
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            '${provider.scanCount}',
                            key: ValueKey<int>(provider.scanCount),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            '${provider.exportsCount}',
                            key: ValueKey<int>(provider.exportsCount),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: provider.projects.isEmpty
                ? Card(
                    key: const ValueKey<String>('empty'),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          const Icon(Icons.inbox_outlined, size: 34),
                          const SizedBox(height: 8),
                          Text(
                            'Aucun scan pour le moment.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          const Text('Lance ton premier scan pour commencer la reconstruction 3D.'),
                        ],
                      ),
                    ),
                  )
                : Column(
                    key: const ValueKey<String>('list'),
                    children: provider.projects
                        .map(
                          (p) => ScanCard(
                            project: p,
                            onTap: () async {
                              await HapticFeedback.selectionClick();
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ScanDetailScreen(projectId: p.id)),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
