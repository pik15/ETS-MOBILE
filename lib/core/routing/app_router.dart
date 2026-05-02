import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/product/presentation/pages/product_page.dart';
import '../../../features/product/presentation/pages/detail_page.dart';
import '../../../features/product/presentation/cubit/product_cubit.dart';
import '../../core/di/injection.dart';
import '../../features/product/presentation/pages/crypto_page.dart';
import '../../features/product/presentation/pages/native_page.dart';
// AKTIFKAN IMPORT INI:
import '../../features/product/presentation/pages/todo_page.dart'; 

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => locator<ProductCubit>()..fetchAllProducts(), 
            child: const ProductPage(),
          );
        },
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return DetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage(),
      ),
      
      // --- MODUL 7: NATIVE FEATURES ---
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage(),
      ),

      // --- MODUL 6: TODO ISAR (SEKARANG SUDAH AKTIF) ---
      GoRoute(
        path: '/todo', 
        builder: (context, state) => const TodoPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Halaman tidak ditemukan!')),
    ),
  );
}