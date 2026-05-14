import 'package:flutter/material.dart';

import '../models/scan_project.dart';
import '../models/scan_status.dart';

class ScanCard extends StatelessWidget {
  final ScanProject project;
  final VoidCallback onTap;

  const ScanCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.view_in_ar_outlined)),
        title: Text(project.name),
        subtitle: Text('${project.imagePaths.length} photos - ${project.status.label}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
