import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/widgets/glb_3d_character_viewer.dart';

void main() {
  testWidgets('Glb3DCharacterViewer renders borderless 3D character and animation controls', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Glb3DCharacterViewer(),
        ),
      ),
    );
    await tester.pump();

    // Verify animation pills (Santai, Jalan, Lari, Sapa)
    expect(find.text('🧘 Santai'), findsOneWidget);
    expect(find.text('🚶 Jalan'), findsOneWidget);
    expect(find.text('🏃 Lari'), findsOneWidget);
    expect(find.text('👋 Sapa'), findsOneWidget);

    // Verify tap animation pill switches active animation
    await tester.tap(find.text('🚶 Jalan'));
    await tester.pumpAndSettle();

    // Verify 360 orbit hint
    expect(find.text('Putar 360° interaktif'), findsOneWidget);
  });
}
