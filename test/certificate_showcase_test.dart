import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/widgets/certificate_showcase.dart';

void main() {
  testWidgets('CertificateShowcaseSection renders certificates and filter chips', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CertificateShowcaseSection(),
          ),
        ),
      ),
    );
    await tester.pump();

    // Verify Section Header
    expect(find.text('SERTIFIKASI & PENGHARGAAN KOMPETENSI'), findsOneWidget);
    expect(find.text('Kredensial Profesional & Prestasi Terverifikasi'), findsOneWidget);

    // Verify Filter Chips exist
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Mobile Dev'), findsWidgets);
    expect(find.text('PBO & Arsitektur'), findsWidgets);
    expect(find.text('UI/UX & Cloud'), findsWidgets);

    // Verify Certificate Titles
    expect(find.text('Flutter & Dart Mobile App Development'), findsOneWidget);
    expect(find.text('Certificate of Excellence: OOP & Software Architecture'), findsOneWidget);
    expect(find.text('Advanced Mobile UI/UX & Cloud Engineering'), findsOneWidget);

    // Verify Credential IDs
    expect(find.text('FD-AF-2024-9371'), findsOneWidget);
    expect(find.text('UGT-PBO-EXC-2023-AF'), findsOneWidget);
    expect(find.text('AFU20230001AMUCE'), findsOneWidget);

    // Tap on 'PBO & Arsitektur' filter chip
    final pboChip = find.widgetWithText(FilterChip, 'PBO & Arsitektur');
    await tester.tap(pboChip);
    await tester.pumpAndSettle();

    // After filtering, PBO cert is still visible, while others are hidden
    expect(find.text('Certificate of Excellence: OOP & Software Architecture'), findsOneWidget);
    expect(find.text('Flutter & Dart Mobile App Development'), findsNothing);
  });
}
