import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/scan_project.dart';

class LocalStorageService {
  Future<Directory> _appDir() async => getApplicationDocumentsDirectory();

  Future<File> _projectsFile() async {
    final dir = await _appDir();
    return File('${dir.path}/scanforge_projects.json');
  }

  Future<void> saveProjects(List<ScanProject> projects) async {
    final file = await _projectsFile();
    final payload = projects.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(payload));
  }

  Future<List<ScanProject>> loadProjects() async {
    final file = await _projectsFile();
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];
    final raw = jsonDecode(content) as List<dynamic>;
    return raw
        .map((e) => ScanProject.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<Directory> ensureProjectPhotoDir(String projectId) async {
    final dir = await _appDir();
    final projectDir = Directory('${dir.path}/projects/$projectId/photos');
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }
    return projectDir;
  }

  Future<void> deleteProjectFiles(String projectId) async {
    final dir = await _appDir();
    final projectDir = Directory('${dir.path}/projects/$projectId');
    if (await projectDir.exists()) {
      await projectDir.delete(recursive: true);
    }
  }
}
