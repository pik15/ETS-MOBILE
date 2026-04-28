import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; // Untuk fungsi jsonDecode [cite: 545]
import 'package:flutter/foundation.dart'; // Untuk fungsi compute() [cite: 695]

// 1. FUNGSI BERAT DI LUAR CLASS (Isolate)
// Wajib berada di luar class agar bisa dijalankan oleh Isolate [cite: 683, 685]
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
  // Menggunakan URL WebSocket yang kamu berikan
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';

  @override
  void initState() {
    super.initState();
    // Menghubungkan ke server WebSocket saat halaman dibuka [cite: 557]
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    // WAJIB! Tutup koneksi saat halaman ditinggalkan agar tidak bocor memori [cite: 567, 568]
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live BTC - Binance Vision'),
        backgroundColor: Colors.orange.shade800, 
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange), 
            const SizedBox(height: 20),
            
            // StreamBuilder otomatis rebuild UI tiap ada data baru masuk [cite: 577, 578]
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Koneksi Error!');
                if (!snapshot.hasData) return const CircularProgressIndicator(); 

                // Cara Parsing Data dari Binance Vision:
                // Data datang sebagai String JSON, kita decode jadi Map [cite: 591, 592]
                final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
                
                // Pada stream Binance, harga berada di key 'p' (price)
                final String price = dataJson['p'] ?? '0.00';
                _currentPrice = double.parse(price).toStringAsFixed(2);

                return Text(
                  '\$ $_currentPrice',
                  style: const TextStyle(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.green
                  ), 
                );
              },
            ),

            const SizedBox(height: 40),
            // Indikator ini akan berhenti jika layar macet (Siksa Main Thread) [cite: 654, 678]
            const CircularProgressIndicator(),
            const SizedBox(height: 20),

            // TOMBOL MERAH (SIMULASI UI MACET) [cite: 656, 657, 658]
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                debugPrint("Main Thread disiksa... Layar akan macet!"); 
                int hasil = 0;
                // Looping berat di Main Thread (UI Thread) 
                for (int i = 0; i < 4000000000; i++) {
                  hasil += i;
                }
                debugPrint("Selesai! Hasil: $hasil"); 
              },
              child: const Text('Siksa Main Thread (Layar Macet)', style: TextStyle(color: Colors.white)), 
            ),

            const SizedBox(height: 10),

            // TOMBOL HIJAU (SOLUSI ISOLATE) [cite: 680, 699, 700]
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                debugPrint("Menghitung di Isolate... Layar tetap lancar!"); 
               
                int hasil = await compute(tugasMenghitungBerat, 4000000000);
                debugPrint("Selesai dari Isolate! Hasil: $hasil"); 
              },
              child: const Text('Gunakan Isolate (Layar Lancar)', style: TextStyle(color: Colors.white)), 
            ),
          ],
        ),
      ),
    );
  }
}