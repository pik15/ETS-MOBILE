import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart'; 
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

// --- TAMBAHKAN IMPORT INI ---
import '../../features/todo/data/isar_service.dart'; 

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register API & Services Dasar
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // 2. Register IsarService agar tidak error "Not Registered"
  // Gunakan LazySingleton karena koneksi database cukup dibuat sekali[cite: 2, 6]
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Register Feature Product
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  locator.registerFactory<ProductService>(() => ProductService(locator()));
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator()));
}