import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Import library Stuntman
// 👇 Sesuaikan import package ini dengan nama proyekmu (android_studio)
import 'package:android_studio/features/auth/auth_service.dart';

// 1. MEMBUAT PEMERAN PENGGANTI (STUNTMAN)
// Kita membuat kelas bohong-bohongan yang mirip dengan ApiClient asli
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthService authService;
  late MockApiClient mockApiClient; // Variabel untuk si Stuntman

  setUp(() {
    // 2. ARRANGE (Persiapan)
    mockApiClient = MockApiClient();
    // Kita berikan si Stuntman kepada AuthService.
    // AuthService tidak akan sadar kalau ini bukan ApiClient asli!
    authService = AuthService(mockApiClient);
  });

  group('AuthService Login Tests -', () {
    test('Harus mengembalikan pesan error jika email kosong', () async {
      // 1. ACT
      final result = await authService.loginUser("", 'password123');
      
      // 2. ASSERT
      expect(result, "Email dan Password tidak boleh kosong!");
      // Pastikan Stuntman tidak pernah disuruh kerja (karena gagal validasi lokal)
      verifyNever(() => mockApiClient.loginKeServer(any(), any()));
    });

    test('Harus mengembalikan "Login Berhasil!" jika API membalas true', () async {
      // 1. ARRANGE (Instruksi Stuntman)
      // Kita bisiki Stuntman: "Nanti kalau disuruh login dengan admin@utd.id,
      // pura-pura proses dan kembalikan nilai TRUE ya!"
      when(() => mockApiClient.loginKeServer('admin@utd.id', 'rahasia123'))
          .thenAnswer((_) async => true);

      // 2. ACT
      final result = await authService.loginUser('admin@utd.id', 'rahasia123');

      // 3. ASSERT
      expect(result, "Login Berhasil!");
      // Buktikan bahwa Stuntman benar-benar dipanggil sebanyak 1 kali
      verify(() => mockApiClient.loginKeServer('admin@utd.id', 'rahasia123')).called(1);
    });

    test('Harus mengembalikan "Terjadi Kesalahan Jaringan" jika API error/mati', () async {
      // 1. ARRANGE (Instruksi Stuntman)
      // Kita bisiki Stuntman: "Nanti pura-pura mati (lempar Exception) ya!"
      when(() => mockApiClient.loginKeServer(any(), any()))
          .thenThrow(Exception('No Internet')); // Pura-pura internet mati

      // 2. ACT
      final result = await authService.loginUser('user@utd.id', 'pass123');

      // 3. ASSERT
      // Buktikan bahwa meskipun API meledak, kode kita menangkapnya dengan aman
      expect(result, "Terjadi Kesalahan Jaringan");
    });

    // 👇 INTEGRASI TUGAS MANDIRI 2 (POST-TEST MODUL 12)
    test('Harus mengembalikan "Kredensial Salah!" jika API membalas false', () async {
      // 1. ARRANGE (Instruksi Stuntman kalau password salah di server)
      when(() => mockApiClient.loginKeServer('admin@utd.id', 'passwordsalah'))
          .thenAnswer((_) async => false);

      // 2. ACT
      final result = await authService.loginUser('admin@utd.id', 'passwordsalah');

      // 3. ASSERT
      expect(result, "Kredensial Salah!");
      verify(() => mockApiClient.loginKeServer('admin@utd.id', 'passwordsalah')).called(1);
    });
  });
}