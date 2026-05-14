import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/scan_provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/export_button.dart';

class ExportScreen extends StatefulWidget {
  final String projectId;
  const ExportScreen({super.key, required this.projectId});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _format = 'STL';
  bool _busy = false;
  String? _lastPath;

  Future<void> _export() async {
    final provider = context.read<ScanProvider>();
    final messenger = ScaffoldMessenger.of(context);
    await HapticFeedback.selectionClick();
    setState(() => _busy = true);
    try {
      final path = await provider.exportProject(
            projectId: widget.projectId,
            format: _format,
          );
      if (!mounted) return;
      await HapticFeedback.mediumImpact();
      setState(() => _lastPath = path);
      messenger.showSnackBar(
        SnackBar(content: Text('Export cree: $path')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    if (_lastPath == null) return;
    await HapticFeedback.lightImpact();
    await Share.shareXFiles([XFile(_lastPath!)]);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Export')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExportButton(
            label: 'STL',
            subtitle: 'Pour imprimante 3D',
            selected: _format == 'STL',
            onTap: () => setState(() => _format = 'STL'),
          ),
          ExportButton(
            label: 'OBJ',
            subtitle: 'Pour modelisation',
            selected: _format == 'OBJ',
            onTap: () => setState(() => _format = 'OBJ'),
          ),
          ExportButton(
            label: 'GLB',
            subtitle: 'Pour apercu 3D',
            selected: _format == 'GLB',
            onTap: () => setState(() => _format = 'GLB'),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: ElevatedButton(
              key: ValueKey<bool>(_busy),
              onPressed: _busy ? null : _export,
              child: Text(_busy ? 'Export en cours...' : 'Exporter'),
            ),
          ),
          OutlinedButton(
            onPressed: (_lastPath != null && File(_lastPath!).existsSync()) ? _share : null,
            child: const Text('Partager'),
          ),
        ],
      ),
    );
  }
}
