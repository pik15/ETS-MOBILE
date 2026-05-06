import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  // 1. WAJIB: Memastikan plugin Flutter terinisialisasi sebelum menjalankan kode async[cite: 2]
  WidgetsFlutterBinding.ensureInitialized();

  // 2. SANGAT PENTING: Panggil Pelayan (GetIt) untuk mendaftarkan IsarService & Cubit[cite: 6]
  setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // Diperbarui menjadi android_studio sesuai nama proyek Anda
      title: 'android_studio', 
      theme: AppTheme.lightTheme, // Menggunakan tema Teal UTD
      routerConfig: AppRouter.router, // Menggunakan navigasi GoRouter[cite: 6]
    );
  }
}