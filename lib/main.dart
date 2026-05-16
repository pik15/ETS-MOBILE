import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

// 1. NAMA TUGAS (Konstanta agar tidak salah ketik)
const String syncTask = "tugas_sinkronisasi_rutin";

// 2. PEKERJA LATAR BELAKANG (Top-Level Function)
// @pragma ini WAJIB agar tidak dihapus compiler saat rilis APK
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Fungsi ini adalah titik masuk saat aplikasi dibangunkan oleh OS
  Workmanager().executeTask((taskName, inputData) async {
    // Mengecek apakah nama tugasnya cocok
    if (taskName == syncTask) {
      try {
        //--- SIMULASI TUGAS BERAT DIMULAI
        // Mengubah print() menjadi debugPrint() untuk mengatasi linter avoid_print
        debugPrint("Mulai mengambil data dari server secara gaib...");
        // Pura-pura butuh waktu 3 detik
        await Future.delayed(const Duration(seconds: 3));
        
        // --- TUGAS SELESAI
        // Catat jam berapa tugas ini berhasil dikerjakan ke memori HP
        final prefs = await SharedPreferences.getInstance();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        await prefs.setString("last_sync_time", "Sinkronisasi diam-diam sukses pada: $currentTime");
        debugPrint("Tugas Latar Belakang Selesai!");
        
        return Future.value(true); // Lapor ke OS kalau sukses!
      } catch (e) {
        debugPrint("Tugas gagal: $e");
        return Future.value(false); // Lapor ke OS kalau gagal
      }
    }
    return Future.value(true);
  });
}

void main() async {
  // 1. WAJIB: Memastikan plugin Flutter terinisialisasi sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inisialisasi WorkManager (Memberikan ID Card ke Satpam)
  // Menghapus parameter 'isInDebugMode' yang sudah deprecated agar warning hilang
  Workmanager().initialize(
    callbackDispatcher,
  );

  // 2. SANGAT PENTING: Panggil Pelayan (GetIt) untuk mendaftarkan IsarService & Cubit
  setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'android_studio', 
      theme: AppTheme.lightTheme, // Menggunakan tema Teal UTD
      routerConfig: AppRouter.router, // Menggunakan navigasi GoRouter
    );
  }
}