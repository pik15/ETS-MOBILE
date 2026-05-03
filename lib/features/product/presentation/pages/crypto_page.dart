import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// 1. FUNGSI BERAT DI LUAR CLASS (Syarat Isolate)
int tugasMenghitungBerat(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';

  @override
  void initState() {
    super.initState();
    // Koneksi ke Binance Vision
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Cegah kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('UTD Crypto Hub', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Color(0xFF1A73E8)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Gradasi dengan Info NIM
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueAccent, Color(0xFF1A73E8)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Monitoring BTC Real-time',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Taupik Anjana - 20123005',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Kartu Monitor Harga
                  _buildPriceCard(),

                  const SizedBox(height: 30),

                  // Indikator UI Lancar (WAJIB: Tidak boleh macet saat Isolate jalan)
                  const Text('UI Responsiveness Check:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Kalkulasi dengan Style Konsisten
                  _buildCalculateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.currency_bitcoin_rounded, size: 80, color: Colors.orange),
          const SizedBox(height: 15),
          const Text(
            'BTC / USDT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('Koneksi Terputus!', style: TextStyle(color: Colors.red));
              if (!snapshot.hasData) return const Text('Memuat Harga...', style: TextStyle(color: Colors.blueAccent));

              final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
              final String price = dataJson['p'] ?? '0.00';
              _currentPrice = double.parse(price).toStringAsFixed(2);

              return Text(
                '\$ $_currentPrice',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32), // Hijau yang lebih tegas
                  letterSpacing: -1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        onPressed: () async {
          debugPrint("Memulai Isolate untuk NIM 20123005...");
          
          // LOGIKA PERSONAL: 05 * 10.000.000 = 50.000.000
          const int nimLoopFactor = 05 * 10000000;

          // Menggunakan Isolate (compute) agar UI tidak freeze
          final result = await compute(tugasMenghitungBerat, nimLoopFactor);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.blueAccent,
                content: Text('Kalkulasi NIM 05 Selesai: $result'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        icon: const Icon(Icons.calculate_rounded),
        label: const Text(
          'KALKULASI PAJAK (ISOLATE NIM 05)',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}