// KODE UTAMA (lib/features/auth/auth_service.dart)

// 1. Kontrak / Interface untuk ApiClient
abstract class ApiClient {
  Future<bool> loginKeServer(String email, String password);
}

// 2. Class utama yang mau kita uji (AuthService)
class AuthService {
  // AuthService butuh ApiClient untuk bekerja (Dependency Injection)
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<String> loginUser(String email, String password) async {
    // Validasi dasar
    if (email.isEmpty || password.isEmpty) {
      return "Email dan Password tidak boleh kosong!";
    }
    
    try {
      // Memanggil layanan API kontrak (Internet)
      final isSuccess = await apiClient.loginKeServer(email, password);
      if (isSuccess) {
        return "Login Berhasil!";
      } else {
        return "Kredensial Salah!";
      }
    } catch (e) {
      // Mengatasi jika ada masalah jaringan/error server
      return "Terjadi Kesalahan Jaringan";
    }
  }
}