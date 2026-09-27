import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/models/user_model.dart';
import 'package:tugas_flutter/pages/pbo_lab_page.dart';

void main() {
  final testUser = MahasiswaAuthorUser(
    id: 'user-01',
    username: 'fauzan',
    displayName: 'Ahmad Fauzan',
    avatarUrl: 'assets/images/avatar_3d.jpg',
    nim: '230101001',
  );

  testWidgets('PboLabPage renders with ListView.builder, Functions stats, and Setter-Getter features', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PboLabPage(currentUser: testUser),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Header & Title
    expect(find.text('Laboratorium PBO: ListBuilder, Function & Setter-Getter'), findsOneWidget);

    // 2. Verify Function Stats Bar (Total Proyek, Rata-rata Nilai, Tingkat Lulus)
    expect(find.text('Total Proyek'), findsOneWidget);
    expect(find.text('Rata-rata Nilai'), findsOneWidget);
    expect(find.text('Tingkat Lulus'), findsOneWidget);

    // 3. Verify ListView.builder renders items (via Getters)
    expect(find.text('PBO-01'), findsOneWidget);
    expect(find.text('Portofolio Digital & Blueprint Lab'), findsOneWidget);
    expect(find.text('PBO-02'), findsOneWidget);

    // 4. Verify Setter dialog trigger button
    expect(find.text('Uji Setter Skor').first, findsOneWidget);
    await tester.tap(find.text('Uji Setter Skor').first);
    await tester.pumpAndSettle();

    // Verify dialog with setter sliders and live computed getter preview
    expect(find.text('Uji Setter Nilai [PBO-01]'), findsOneWidget);
    expect(find.text('Terapkan via Setter'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // 5. Verify Tab Switch to Source Code Inspector
    await tester.tap(find.text('2. Kode Sumber PBO (ListBuilder, Function, Setter/Getter)'));
    await tester.pumpAndSettle();

    expect(find.text('FITUR 1: ListView.builder (ListBuilder)'), findsOneWidget);
    expect(find.text('FITUR 2: Functions (Fungsi & Metode Perhitungan)'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('FITUR 3: Setter & Getter (Enkapsulasi Private Field)'), findsOneWidget);
  });
}
