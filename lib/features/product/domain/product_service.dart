import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  // Mengubah menjadi Future dan menggunakan async/await sesuai modul
  Future<List<Product>> fetchProducts() async {
    // LOGIKA PERSONAL (ANTI-AI):
    // Aplikasi wajib melakukan delay persis selama X detik, 
    // di mana X adalah digit terakhir NIM (NIM: 20123005 -> 5 detik).
    // Delay ini harus diatur di level Service/Domain, bukan di UI.
    await Future.delayed(const Duration(seconds: 5)); 

    return await repository.getAllProducts();
  }

  // Mengubah menjadi Future untuk mengambil detail produk
  Future<Product?> fetchProductDetail(String id) async {
    return await repository.getProductById(id);
  }
}