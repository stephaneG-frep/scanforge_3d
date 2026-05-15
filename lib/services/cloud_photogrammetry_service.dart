import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudPhotogrammetryService {
  static const String _baseUrl = String.fromEnvironment('PHOTOGRAMMETRY_API_BASE_URL');
  static const String _apiKey = String.fromEnvironment('PHOTOGRAMMETRY_API_KEY');

  bool get isConfigured => _baseUrl.isNotEmpty && _apiKey.isNotEmpty;

  Future<String> runCloudPipeline({
    required String projectId,
    required List<String> imagePaths,
    required void Function(int stepIndex) onStep,
  }) async {
    if (!isConfigured) {
      throw Exception('Cloud API non configuree');
    }
    if (imagePaths.isEmpty) {
      throw Exception('Aucune image a envoyer');
    }

    onStep(0); // Analyse des photos
    final jobId = await _createJob(projectId: projectId, imagePaths: imagePaths);

    // Polling until completed/failed.
    String? modelUrl;
    for (int attempt = 0; attempt < 120; attempt++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final state = await _getJobState(jobId);

      final status = (state['status'] ?? '').toString().toLowerCase();
      if (status.contains('queue') || status.contains('wait')) {
        onStep(1);
      } else if (status.contains('process') || status.contains('match')) {
        onStep(2);
      } else if (status.contains('mesh') || status.contains('reconstruct')) {
        onStep(3);
      } else if (status.contains('clean') || status.contains('optimiz')) {
        onStep(4);
      }

      if (status == 'completed' || status == 'done' || status == 'success') {
        modelUrl = _extractModelUrl(state);
        break;
      }
      if (status == 'failed' || status == 'error') {
        throw Exception('Traitement cloud en echec');
      }
    }

    if (modelUrl == null || modelUrl.isEmpty) {
      throw Exception('Modele cloud indisponible ou timeout');
    }

    return modelUrl;
  }

  Future<String> _createJob({
    required String projectId,
    required List<String> imagePaths,
  }) async {
    final uri = Uri.parse('$_baseUrl/v1/reconstructions');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..fields['projectId'] = projectId;

    for (final path in imagePaths) {
      final file = File(path);
      if (!await file.exists()) continue;
      request.files.add(await http.MultipartFile.fromPath('images', path));
    }

    final streamed = await request.send();
    final responseBody = await streamed.stream.bytesToString();
    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw Exception('Creation job cloud impossible (${streamed.statusCode})');
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    final jobId = (data['jobId'] ?? data['id'] ?? '').toString();
    if (jobId.isEmpty) {
      throw Exception('Reponse cloud invalide: jobId manquant');
    }
    return jobId;
  }

  Future<Map<String, dynamic>> _getJobState(String jobId) async {
    final uri = Uri.parse('$_baseUrl/v1/reconstructions/$jobId');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Lecture statut cloud impossible (${response.statusCode})');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  String? _extractModelUrl(Map<String, dynamic> state) {
    final direct = state['modelUrl']?.toString();
    if (direct != null && direct.isNotEmpty) return direct;

    final output = state['output'];
    if (output is Map<String, dynamic>) {
      final glb = output['glbUrl']?.toString();
      if (glb != null && glb.isNotEmpty) return glb;
      final model = output['model']?.toString();
      if (model != null && model.isNotEmpty) return model;
    }

    return null;
  }
}
