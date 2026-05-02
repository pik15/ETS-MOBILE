import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Wajib untuk fungsi compute()

// 1. FUNGSI BERAT DI LUAR CLASS (Isolate)
// Wajib berada di luar class agar bisa dijalankan oleh Isolate (Pekerja Gudang)
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
  // Menggunakan URL WebSocket Binance Vision[cite: 5]
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';

  @override
  void initState() {
    super.initState();
    // Menghubungkan telepon ke Server (WebSocket)[cite: 5]
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    // WAJIB! Tutup koneksi agar tidak bocor memori[cite: 5]
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('UTD Crypto Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange.shade800,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
            const SizedBox(height: 10),
            const Text('BTC / USDT (Real-time)', style: TextStyle(fontSize: 16)),
            
            // StreamBuilder otomatis rebuild UI tiap ada data baru masuk[cite: 5]
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Koneksi Terputus!', style: TextStyle(color: Colors.red));
                if (!snapshot.hasData) return const CircularProgressIndicator();

                // Parsing JSON dari Binance (key 'p' adalah price)[cite: 5]
                final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
                final String price = dataJson['p'] ?? '0.00';
                _currentPrice = double.parse(price).toStringAsFixed(2);

                return Text(
                  '\$ $_currentPrice',
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            // Indikator ini TIDAK BOLEH FREEZE saat kalkulasi berjalan
            const CircularProgressIndicator(color: Colors.blueAccent),
            const SizedBox(height: 20),

            // TOMBOL HIJAU (SOLUSI ISOLATE)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                debugPrint("Memulai Isolate untuk NIM 20123005...");
                
                // LOGIKA PERSONAL ANTI-AI (NIM 05):
                // [2 Digit Terakhir NIM] x 10.000.000
                // 05 * 10.000.000 = 50.000.000
                const int nimLoopFactor = 05 * 10000000;

                // Memanggil Isolate agar UI tetap lancar[cite: 5]
                final result = await compute(tugasMenghitungBerat, nimLoopFactor);

                debugPrint("Selesai! Hasil: $result");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kalkulasi NIM 05 Selesai: $result')),
                  );
                }
              },
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text(
                'Kalkulasi Pajak (Isolate NIM 05)', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
            
            const SizedBox(height: 20),
            Text(
              'Taupik Anjana - 20123005',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}