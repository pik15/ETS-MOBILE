import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  // Mengubah menjadi Future dan menggunakan async/await sesuai modul
  Future<List<Product>> fetchProducts() async {
    return await repository.getAllProducts();
  }

  // Mengubah menjadi Future untuk mengambil detail produk
  Future<Product?> fetchProductDetail(String id) async {
    return await repository.getProductById(id);
  }
}