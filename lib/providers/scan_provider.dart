import 'dart:io';

import 'package:flutter/material.dart';

import '../models/scan_project.dart';
import '../models/scan_status.dart';
import '../services/export_service.dart';
import '../services/fake_photogrammetry_service.dart';
import '../services/local_storage_service.dart';

class ScanProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final FakePhotogrammetryService _fakeService = FakePhotogrammetryService();
  final ExportService _exportService = ExportService();

  final List<ScanProject> _projects = [];
  int _exportsCount = 0;

  List<ScanProject> get projects => List.unmodifiable(_projects);
  int get scanCount => _projects.length;
  int get exportsCount => _exportsCount;

  Future<void> loadProjects() async {
    _projects
      ..clear()
      ..addAll(await _storage.loadProjects());
    _exportsCount = _projects.fold<int>(0, (sum, p) => sum + p.exportPaths.length);
    notifyListeners();
  }

  Future<ScanProject> createProject() async {
    final now = DateTime.now();
    final project = ScanProject(
      id: now.microsecondsSinceEpoch.toString(),
      name: 'Scan ${_projects.length + 1}',
      createdAt: now,
      imagePaths: const [],
      status: ScanStatus.capturing,
      modelPath: null,
      exportPaths: const {},
    );
    _projects.insert(0, project);
    await _persist();
    notifyListeners();
    return project;
  }

  ScanProject getById(String id) => _projects.firstWhere((p) => p.id == id);

  Future<void> addPhoto({required String projectId, required String sourcePath}) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index < 0) return;

    final dir = await _storage.ensureProjectPhotoDir(projectId);
    final filename = 'img_${DateTime.now().microsecondsSinceEpoch}.jpg';
    final target = File('${dir.path}/$filename');
    await File(sourcePath).copy(target.path);

    final updatedPaths = [..._projects[index].imagePaths, target.path];
    _projects[index] = _projects[index].copyWith(
      imagePaths: updatedPaths,
      status: ScanStatus.capturing,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> processProject({
    required String projectId,
    required void Function(int stepIndex) onStep,
  }) async {
    final i = _projects.indexWhere((p) => p.id == projectId);
    if (i < 0) return;

    _projects[i] = _projects[i].copyWith(status: ScanStatus.processing);
    notifyListeners();
    await _persist();

    try {
      await _fakeService.runFakePipeline(project: _projects[i], onStep: onStep);
      _projects[i] = _projects[i].copyWith(
        status: ScanStatus.completed,
        modelPath: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      );
    } catch (_) {
      _projects[i] = _projects[i].copyWith(status: ScanStatus.failed);
    }

    await _persist();
    notifyListeners();
  }

  Future<String> exportProject({required String projectId, required String format}) async {
    final i = _projects.indexWhere((p) => p.id == projectId);
    if (i < 0) throw Exception('Projet introuvable');

    final path = await _exportService.simulateExport(projectId: projectId, format: format);
    final exports = Map<String, String>.from(_projects[i].exportPaths);
    exports[format] = path;
    _projects[i] = _projects[i].copyWith(exportPaths: exports);
    _exportsCount += 1;
    await _persist();
    notifyListeners();
    return path;
  }

  Future<void> deleteProject(String projectId) async {
    final i = _projects.indexWhere((p) => p.id == projectId);
    if (i < 0) return;
    _exportsCount -= _projects[i].exportPaths.length;
    _projects.removeAt(i);
    await _storage.deleteProjectFiles(projectId);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() => _storage.saveProjects(_projects);
}
