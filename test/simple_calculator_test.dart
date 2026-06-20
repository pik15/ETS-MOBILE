import 'package:flutter_test/flutter_test.dart';
// 👇 Sesuaikan import package ini dengan nama proyekmu (android_studio)
import 'package:android_studio/features/calculator/simple_calculator.dart';

void main() {
  // group() digunakan untuk mengelompokkan pengujian yang mirip
  group('Pengujian SimpleCalculator -', () {
    // Siapkan wadah untuk kelas yang mau diuji
    late SimpleCalculator calculator;

    // setUp() akan dijalankan SEBELUM setiap test() dimulai
    setUp(() {
      calculator = SimpleCalculator(); // [ARRANGE] (Persiapan data/objek)
    });

    // Robot 1: Menguji fungsi pertambahan
    test('Fungsi add() harus mengembalikan hasil 5 jika 2 ditambah 3', () {
      // 1. ACT (Aksi memanggil fungsi)
      final result = calculator.add(2, 3);
      
      // 2. ASSERT (Pembuktian mencocokkan ekspektasi)
      expect(result, 5);
    });

    // Robot 2: Menguji perhitungan diskon
    test('Fungsi calculateDiscount() harus mengembalikan 8000 jika harga 10000 diskon 20%', () {
      // 1. ACT
      final result = calculator.calculateDiscount(10000, 20);
      
      // 2. ASSERT
      expect(result, 8000);
    });

    // Robot 3: Menguji Error (Exception)
    test('Fungsi calculateDiscount() harus melempar error jika diskon 150%', () {
      // Untuk menguji error, kita membungkus Act di dalam penangkap error 'throwsArgumentError'
      expect(
        () => calculator.calculateDiscount(10000, 150), // ACT
        throwsArgumentError, // ASSERT: Kita berekspektasi ini akan meledak!
      );
    });
  });
}