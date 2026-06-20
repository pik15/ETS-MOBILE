import 'dart:io'; // Penting untuk menangani sertifikat SSL
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // Penting untuk HttpClientAdapter
import 'package:logger/logger.dart';

// 👇 IMPORT BARU MODUL 11: Konfigurasi Environment
import '../config/env_config.dart'; // Jangan lupa sesuaikan path import config kamu [cite: 311]

class ApiClient {
  final Dio dio;
  final Logger logger = Logger(); // Alat cetak log keren

  ApiClient() : dio = Dio() {
    // 1. Konfigurasi Dasar (Global)
    // 👇 SEKARANG BASE URL BERUBAH SECARA OTOMATIS SESUAI FLAVOR TERMINAL!
    dio.options.baseUrl = EnvConfig.baseUrl; // 
    
    // Perpanjang waktu tunggu ke 30 detik agar lebih stabil jika internet lambat 
    dio.options.connectTimeout = const Duration(seconds: 30); 
    dio.options.receiveTimeout = const Duration(seconds: 30); 

    // SOLUSI UNTUK ERROR 526: Mengabaikan pemeriksaan sertifikat SSL yang tidak valid
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 2. Menambahkan Interceptor (Satpam)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Mencetak log saat mengirim request
          logger.i('MENGIRIM REQUEST: [${options.method}] ${options.uri}');
          
          // Tempat menyisipkan Token jika API butuh login
          return handler.next(options); // Lanjutkan request
        },
        onResponse: (response, handler) {
          // Mencetak log saat berhasil mendapat data
          logger.i('BERHASIL [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response); // Lanjutkan response ke aplikasi
        },
        onError: (DioException e, handler) {
          // Mencetak log saat terjadi error
          logger.e('X ERROR [${e.response?.statusCode}]: ${e.requestOptions.uri}');
          logger.e('PESAN: ${e.message}');
          
          return handler.next(e); // Lanjutkan error agar ditangkap oleh aplikasi
        },
      ),
    );
  }
}