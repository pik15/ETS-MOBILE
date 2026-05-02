// lib/features/product/presentation/cubit/product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../domain/product_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;

  // Gunakan ProductLoading sebagai state awal agar UI langsung memicu loading
  ProductCubit(this._service) : super(ProductLoading());

  // Gunakan nama 'fetchAllProducts' agar sinkron dengan UI ProductPage Anda[cite: 1, 7]
  Future<void> fetchAllProducts() async {
    emit(ProductLoading());

    try {
      // Ini akan memicu delay 5 detik yang ada di ProductService
      final data = await _service.fetchProducts();
      emit(ProductLoaded(data));
    } catch (e) {
      emit(ProductError('Gagal memuat produk: $e'));
    }
  }
}