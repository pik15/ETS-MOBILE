import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../../core/di/injection.dart'; // Import locator
import '../../../../core/network/api_client.dart'; // Import ApiClient

class ProductRepository {
  // Ambil ApiClient (Dio) dari Pelayan (get_it)
  final ApiClient _apiClient = locator<ApiClient>();

  // Fungsi kini menjadi Future (Asynchronous) karena butuh waktu internet
  Future<List<Product>> getAllProducts() async {
    try {
      // Menembak URL: https://fakestoreapi.com/products[cite: 6]
      final response = await _apiClient.dio.get('/products');
      
      // Dio otomatis membaca response sebagai List (Array JSON)[cite: 6]
      final List<dynamic> jsonList = response.data;
      
      // Mengubah List JSON menjadi List Objek Product dengan Logika Personal
      return jsonList.map((json) {
        final product = Product.fromJson(json);

        // LOGIKA PERSONAL NIM GANJIL (20123005): 
        // Wajib menambahkan teks [Diskon 10%] di belakang nama produk
        // Pastikan Anda memiliki method copyWith pada model Product Anda
        return product.copyWith(
          name: "${product.name} [Diskon 10%]",
        );
      }).toList();
    } on DioException catch (e) {
      // Jika internet mati atau API down, lemparkan error ke atas[cite: 2, 6]
      throw Exception('Gagal memuat jaringan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Ambil 1 produk berdasarkan ID[cite: 6]
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      final product = Product.fromJson(response.data);

      // Tetap terapkan logika manipulasi untuk konsistensi di halaman detail[cite: 1]
      return product.copyWith(
        name: "${product.name} [Diskon 10%]",
      );
    } catch (e) {
      return null;
    }
  }
}