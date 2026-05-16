import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Core & DI
import '../../core/di/injection.dart';

// Import Pages
import '../../../features/product/presentation/pages/product_page.dart';
import '../../../features/product/presentation/pages/detail_page.dart';
import '../../../features/product/presentation/pages/crypto_page.dart';
import '../../../features/product/presentation/pages/native_page.dart';
import '../../../features/product/presentation/pages/todo_page.dart';
import '../../../features/product/presentation/pages/splash_page.dart'; 
// 👇 Import Baru Modul 9: Background Processing
import '../../../features/sync/presentation/pages/background_sync_page.dart';

// Import Cubit
import '../../../features/product/presentation/cubit/product_cubit.dart';

class AppRouter {
  static final router = GoRouter(
    // Lokasi awal diubah ke /splash sesuai instruksi ETS
    initialLocation: '/splash', 
    
    routes: [
      // --- SPLASH SCREEN (Halaman Pertama) ---
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // --- HOME / KATALOG PRODUK ---
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            // Inisialisasi Cubit melalui Service/Locator
            create: (context) => locator<ProductCubit>()..fetchAllProducts(), 
            child: const ProductPage(),
          );
        },
      ),

      // --- DETAIL PRODUK ---
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return DetailPage(productId: productId);
        },
      ),

      // --- MODUL 5: REAL-TIME CRYPTO ---
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage(),
      ),
      
      // --- MODUL 7: NATIVE FEATURES ---
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage(),
      ),

      // --- MODUL 6: OFFLINE NOTES (ISAR) ---
      GoRoute(
        path: '/todo', 
        builder: (context, state) => const TodoPage(),
      ),

      // 👇 --- MODUL 9: BACKGROUND PROCESSING & SCHEDULERS ---
      GoRoute(
        path: '/sync', 
        builder: (context, state) => const BackgroundSyncPage(),
      ),
    ],

    // Penanganan Error jika rute tidak ditemukan
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Halaman tidak ditemukan!')),
    ),
  );
}