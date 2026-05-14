import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/scan_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScanProvider()..loadProjects(),
      child: const ScanForgeApp(),
    ),
  );
}
