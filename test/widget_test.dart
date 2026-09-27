// Test dasar untuk aplikasi Nyesel: memastikan layar utama tampil
// dan alur buka form tambah pengeluaran berjalan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nyesel/main.dart';

void main() {
  setUp(() {
    // Supaya SharedPreferences tidak membaca state asli perangkat saat test.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('NyeselHome menampilkan judul dan tombol tambah',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Nyesel'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Tombol tambah membuka form pengeluaran',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Pengeluaran'), findsOneWidget);
  });
}