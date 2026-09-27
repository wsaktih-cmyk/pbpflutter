import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/widgets/circular_profile_avatar.dart';
import 'package:tugas_flutter/widgets/profile_3d_inspector_dialog.dart';

void main() {
  testWidgets('CircularProfileAvatar 3D renders with orbit satellites', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProfileAvatar(
              radius: 90,
              showOrbitBadges: true,
              enable3DTilt: true,
            ),
          ),
        ),
      ),
    );

    // Initial pump and advance animation frame
    await tester.pump(const Duration(milliseconds: 100));

    // Verify presence of 3D Orbit Badges
    expect(find.text('Flutter 3D'), findsOneWidget);
    expect(find.text('Dart OOP'), findsOneWidget);
    expect(find.text('PBO A+'), findsOneWidget);
    expect(find.text('Architect'), findsOneWidget);
    expect(find.text('3D HOLO A+'), findsOneWidget);
  });

  testWidgets('Profile3DInspectorDialog renders telemetry and 3D controls', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Profile3DInspectorDialog(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));

    // Verify Sci-Fi Telemetry & Headers
    expect(find.text('3D HOLOGRAPHIC PROFILE ARCHITECT'), findsOneWidget);
    expect(find.text('LIVE 3D'), findsOneWidget);
    expect(find.text('KONTROL DINAMIKA 3D'), findsOneWidget);
    expect(find.text('DATA CETAK BIRU OBJEK MAHASISWA (PBO BLUEPRINT)'), findsOneWidget);

    // Verify 3D Skin Selector
    expect(find.text('🤖 3D Cyber Dev'), findsOneWidget);
    expect(find.text('🌐 Holo Matrix'), findsOneWidget);
    expect(find.text('📷 Realistis'), findsOneWidget);
  });
}
