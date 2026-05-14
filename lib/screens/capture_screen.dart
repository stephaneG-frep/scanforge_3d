import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/scan_provider.dart';
import '../widgets/capture_tips_card.dart';
import 'processing_screen.dart';

class CaptureScreen extends StatefulWidget {
  final String projectId;
  const CaptureScreen({super.key, required this.projectId});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 90);
      if (image != null && mounted) {
        await context.read<ScanProvider>().addPhoto(
              projectId: widget.projectId,
              sourcePath: image.path,
            );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = context.watch<ScanProvider>().getById(widget.projectId);
    final count = project.imagePaths.length;
    final progress = (count / 40).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Capture guidee')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(value: progress, strokeWidth: 7),
                        Center(child: Text('${(progress * 100).round()}%')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '$count/40 photos recommandees',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const CaptureTipsCard(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Capturer'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Importer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: count >= 10
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProcessingScreen(projectId: widget.projectId),
                      ),
                    )
                : null,
            child: const Text('Lancer le traitement'),
          ),
        ],
      ),
    );
  }
}
