import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../domain/product_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;

  ProductCubit(this._service) : super(ProductInitial()) {
    // Tambahkan ini agar saat aplikasi dibuka, data langsung ditarik otomatis
    fetchProducts();
  }

  // GANTI NAMA DARI fetchAllProducts MENJADI fetchProducts
  // Agar sesuai dengan tombol refresh di ProductPage
  Future<void> fetchProducts() async {
    emit(ProductLoading());

    try {
      final data = await _service.fetchProducts();
      emit(ProductLoaded(data));
    } catch (e) {
      emit(ProductError('Gagal memuat produk: $e'));
    }
  }
}