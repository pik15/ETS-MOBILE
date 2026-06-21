import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 👇 Sesuaikan import package ini dengan nama proyekmu (android_studio)
import 'package:android_studio/features/auth/presentation/pages/login_screen.dart';

void main() {
  // Widget Test menggunakan fungsi testWidgets, BUKAN test biasa!
  testWidgets('Harus memunculkan error merah jika login diklik saat form kosong',
      (WidgetTester tester) async {
    // 1. ARRANGE (Persiapan)
    // Robot harus memompa/menggambar Widget LoginScreen ke dalam kanvas virtualnya
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Kita cek dulu, tulisan error-nya di awal harusnya TIDAK ADA
    expect(find.text('Email dan Password wajib diisi!'), findsNothing);

    // 2. ACT (Aksi)
    // Robot mencari tombol berdasarkan Key yang sudah kita pasang di UI, lalu mengkliknya!
    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);

    // WAJIB: Setelah diklik, kita suruh waktu berputar agar layar tergambar ulang (Rebuild)
    // pumpAndSettle memajukan waktu sampai semua animasi selesai dan layar benar-benar diam
    await tester.pumpAndSettle();

    // 3. ASSERT (Pembuktian)
    // Sekarang, tulisan error merah tersebut HARUS ADA di layar (findsOneWidget)!
    expect(find.text('Email dan Password wajib diisi!'), findsOneWidget);
  });
}