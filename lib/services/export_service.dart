import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> simulateExport({
    required String projectId,
    required String format,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final outDir = Directory('${dir.path}/projects/$projectId/exports');
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }

    final file = File('${outDir.path}/model.${format.toLowerCase()}');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    await file.writeAsString(
      'ScanForge3D fake export for project $projectId in $format format',
    );
    return file.path;
  }
}
