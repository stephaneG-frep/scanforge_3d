import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_provider.dart';
import '../widgets/progress_stepper.dart';
import 'scan_detail_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String projectId;
  const ProcessingScreen({super.key, required this.projectId});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  static const _steps = [
    'Analyse des photos',
    'Detection des points communs',
    'Reconstruction du maillage',
    'Nettoyage du modele',
    'Preparation export STL',
  ];

  int _currentStep = -1;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await context.read<ScanProvider>().processProject(
          projectId: widget.projectId,
          onStep: (step) {
            if (!mounted) return;
            setState(() => _currentStep = step);
          },
        );
    if (!mounted) return;
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traitement')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
            const SizedBox(height: 14),
            Text(
              _done ? 'Traitement termine' : 'Traitement en cours...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: ProgressStepper(steps: _steps, currentStep: _currentStep),
              ),
            ),
            if (_done)
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanDetailScreen(projectId: widget.projectId),
                  ),
                ),
                child: const Text('Voir le projet'),
              ),
          ],
        ),
      ),
    );
  }
}
