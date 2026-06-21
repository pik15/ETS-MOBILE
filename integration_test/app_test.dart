import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// 👇 Impor pintu masuk utama aplikasimu
import 'package:android_studio/main.dart' as app;

void main() {
  // Menghubungkan tes ke mesin Emulator / HP Fisik [cite: 826]
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End: Alur Login Admin Sukses', (WidgetTester tester) async {
    // 1. ARRANGE: Jalankan Aplikasi Utama [cite: 828, 829]
    app.main(); 
    
    // Tunggu sampai aplikasi selesai loading awal [cite: 830]
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. ACT: Robot mulai mengetik & mengklik otomatis [cite: 832]
    // Mengetik Email [cite: 833]
    final fieldEmail = find.byKey(const Key('field_email'));
    await tester.enterText(fieldEmail, 'admin@utd.id');

    // Mengetik Password [cite: 834]
    final fieldPassword = find.byKey(const Key('field_password'));
    await tester.enterText(fieldPassword, 'rahasia123');

    // Menutup keyboard virtual biar tombol tidak terhalang [cite: 835]
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Menekan tombol Login [cite: 836, 837]
    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);

    // Tunggu animasi transisi pindah halaman selesai [cite: 838]
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 3. ASSERT: Pembuktian hasil [cite: 839]
    // Memastikan teks Selamat Datang muncul di layar beranda [cite: 840]
    expect(find.text('Selamat Datang Admin!'), findsOneWidget);
    
    // Memastikan form login sudah hilang karena sudah pindah layar [cite: 841, 843]
    expect(find.text('LOGIN SEKARANG'), findsNothing);
  });
}