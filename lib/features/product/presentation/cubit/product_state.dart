import 'package:equatable/equatable.dart';
import '../../domain/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// 1. Indikator Awal (Sebelum ada aksi apa pun)
class ProductInitial extends ProductState {}

// 2. Indikator Loading (Sedang mengambil data dari API)
class ProductLoading extends ProductState {}

// 3. Indikator Sukses (Berhasil membawa data dari internet)
class ProductLoaded extends ProductState {
  final List<Product> products;
  
  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

// 4. Indikator Error (Terjadi kegagalan jaringan/sistem)
class ProductError extends ProductState {
  final String message;
  
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}