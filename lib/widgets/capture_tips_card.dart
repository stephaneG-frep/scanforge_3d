import 'package:flutter/material.dart';

class CaptureTipsCard extends StatelessWidget {
  const CaptureTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = const [
      'Tourne lentement autour de l\'objet',
      'Garde la meme distance',
      'Utilise une lumiere diffuse',
      'Evite les objets brillants ou transparents',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conseils capture', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
