import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scanforge_3d/app.dart';
import 'package:scanforge_3d/providers/scan_provider.dart';

void main() {
  testWidgets('Home loads ScanForge title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ScanProvider(),
        child: const ScanForgeApp(),
      ),
    );

    expect(find.text('ScanForge 3D'), findsOneWidget);
  });
}
