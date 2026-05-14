import '../models/scan_project.dart';

class FakePhotogrammetryService {
  Future<void> runFakePipeline({
    required ScanProject project,
    required void Function(int stepIndex) onStep,
  }) async {
    for (int i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      onStep(i);
    }
  }
}
