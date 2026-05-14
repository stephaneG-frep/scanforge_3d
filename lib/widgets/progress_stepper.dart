import 'package:flutter/material.dart';

class ProgressStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const ProgressStepper({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final done = index <= currentStep;
        return ListTile(
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: done ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
            child: Icon(done ? Icons.check : Icons.hourglass_empty, size: 14),
          ),
          title: Text(steps[index]),
        );
      }),
    );
  }
}
