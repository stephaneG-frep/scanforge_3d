import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelPreviewScreen extends StatelessWidget {
  final String modelPath;
  const ModelPreviewScreen({super.key, required this.modelPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apercu 3D')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Apercu du modele reconstruit'),
          ),
          Expanded(
            child: ModelViewer(
              src: modelPath,
              alt: 'Model 3D',
              ar: false,
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
            ),
          ),
        ],
      ),
    );
  }
}
