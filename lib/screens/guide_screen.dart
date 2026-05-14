import 'package:flutter/material.dart';

import '../widgets/gradient_scaffold.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Guide de scan 3D')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.light_mode_outlined),
            title: Text('Eclairage'),
            subtitle: Text('Utilise une lumiere diffuse et evite les ombres dures.'),
          ),
          ListTile(
            leading: Icon(Icons.threesixty),
            title: Text('Rotation autour de l\'objet'),
            subtitle: Text('Capture tous les angles en gardant une vitesse reguliere.'),
          ),
          ListTile(
            leading: Icon(Icons.straighten),
            title: Text('Distance stable'),
            subtitle: Text('Garde une distance constante pour faciliter la reconstruction.'),
          ),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded),
            title: Text('Materiaux difficiles'),
            subtitle: Text('Objets transparents ou brillants = resultats moins stables.'),
          ),
        ],
      ),
    );
  }
}
