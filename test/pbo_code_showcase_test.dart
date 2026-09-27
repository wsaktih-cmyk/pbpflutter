import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/widgets/pbo_code_showcase.dart';

void main() {
  testWidgets('PboCodeShowcase renders code tabs and switches correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PboCodeShowcase(),
          ),
        ),
      ),
    );
    await tester.pump();

    // Verify header and tab buttons exist
    expect(find.text('KODE SUMBER IMPLEMENTASI PBO MURNI'), findsOneWidget);
    expect(find.text('Setter Tervalidasi'), findsWidgets);
    expect(find.text('Getter (Computed)'), findsWidgets);
    expect(find.text('Enkapsulasi & Blueprint'), findsWidgets);
    expect(find.text('Methods & Functions'), findsWidgets);
    expect(find.text('Pewarisan & Polimorfisme'), findsWidgets);

    // Initial state: Setter tab is active
    expect(find.textContaining('PBO: SETTER TERVALIDASI DENGAN EXCEPTION HANDLING'), findsOneWidget);
    expect(find.text('lib/models/student_model.dart'), findsWidgets);

    // Tap on 'Getter (Computed)' tab
    final getterTab = find.text('Getter (Computed)').first;
    await tester.tap(getterTab);
    await tester.pumpAndSettle();

    // Verify Getter code snippet is rendered
    expect(find.textContaining('PBO: GETTER READ-ONLY & COMPUTED PROPERTIES'), findsOneWidget);

    // Tap on 'Enkapsulasi & Blueprint' tab
    final enkapsulasiTab = find.text('Enkapsulasi & Blueprint').first;
    await tester.tap(enkapsulasiTab);
    await tester.pumpAndSettle();

    // Verify Blueprint code snippet is rendered
    expect(find.textContaining('PBO: ENKAPSULASI ATRIBUT PRIVAT & MULTIPLE CONSTRUCTORS'), findsOneWidget);

    // Tap on 'Methods & Functions' tab
    final methodsTab = find.text('Methods & Functions').first;
    await tester.tap(methodsTab);
    await tester.pumpAndSettle();

    // Verify Methods code snippet is rendered
    expect(find.textContaining('PBO: FUNCTIONS / METHODS OPERASIONAL OBJEK'), findsOneWidget);
  });
}
