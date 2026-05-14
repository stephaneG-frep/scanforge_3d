import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/scan_provider.dart';
import '../models/scan_status.dart';
import '../widgets/gradient_scaffold.dart';
import 'capture_screen.dart';
import 'export_screen.dart';
import 'model_preview_screen.dart';

class ScanDetailScreen extends StatelessWidget {
  final String projectId;
  const ScanDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanProvider>();
    final project = provider.getById(projectId);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(project.createdAt);

    return GradientScaffold(
      appBar: AppBar(title: Text(project.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Date: $formattedDate'),
                  Text('Photos: ${project.imagePaths.length}'),
                  Text('Statut: ${project.status.label}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: project.modelPath != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModelPreviewScreen(modelPath: project.modelPath!),
                      ),
                    )
                : null,
            icon: const Icon(Icons.view_in_ar_outlined),
            label: const Text('Voir modele 3D'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ExportScreen(projectId: project.id)),
            ),
            icon: const Icon(Icons.ios_share_outlined),
            label: const Text('Exporter'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CaptureScreen(projectId: project.id)),
            ),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Reprendre des photos'),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final providerRead = context.read<ScanProvider>();
              final navigator = Navigator.of(context);
              await HapticFeedback.heavyImpact();
              await providerRead.deleteProject(project.id);
              if (!context.mounted) return;
              navigator.pop();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
