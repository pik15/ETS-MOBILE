import 'dart:io'; // Penting untuk menangani sertifikat SSL
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // Penting untuk HttpClientAdapter
import 'package:logger/logger.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger(); // Alat cetak log keren [cite: 86]

  ApiClient() : dio = Dio() {
    // 1. Konfigurasi Dasar (Global)
    // Kita pakai API publik gratis [cite: 89]
    dio.options.baseUrl = 'https://api.escuelajs.co/api/v1'; 
    
    // Perpanjang waktu tunggu ke 30 detik agar lebih stabil jika internet lambat 
    dio.options.connectTimeout = const Duration(seconds: 30); 
    dio.options.receiveTimeout = const Duration(seconds: 30); 

    // SOLUSI UNTUK ERROR 526: Mengabaikan pemeriksaan sertifikat SSL yang tidak valid
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 2. Menambahkan Interceptor (Satpam) [cite: 91]
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Mencetak log saat mengirim request [cite: 96]
          logger.i('MENGIRIM REQUEST: [${options.method}] ${options.uri}');
          
          // Tempat menyisipkan Token jika API butuh login [cite: 97]
          return handler.next(options); // Lanjutkan request [cite: 98]
        },
        onResponse: (response, handler) {
          // Mencetak log saat berhasil mendapat data [cite: 101]
          logger.i('BERHASIL [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response); // Lanjutkan response ke aplikasi [cite: 102]
        },
        onError: (DioException e, handler) {
          // Mencetak log saat terjadi error [cite: 104]
          logger.e('X ERROR [${e.response?.statusCode}]: ${e.requestOptions.uri}');
          logger.e('PESAN: ${e.message}');
          
          return handler.next(e); // Lanjutkan error agar ditangkap oleh aplikasi [cite: 105]
        },
      ),
    );
  }
}