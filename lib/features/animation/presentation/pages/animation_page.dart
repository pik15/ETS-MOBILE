import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

// Menggunakan TickerProviderStateMixin karena kita akan membuat 2 controller (Bintang + Lottie)
class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  // 1. Siapkan Mesin Waktu (Controller)
  late AnimationController _spinController;
  late AnimationController _lottieController; // Controller untuk Lottie

  @override
  void initState() {
    super.initState();

    // 2. Inisialisasi Mesin Putar Bintang
    _spinController = AnimationController(
      vsync: this, // Menghubungkan ke Ticker halaman ini
      duration: const Duration(seconds: 2), // 1 putaran penuh = 2 detik
    );

    // Perintahkan mesin untuk jalan dan mengulang terus-menerus (loop)
    _spinController.repeat();

    // 3. Inisialisasi Controller Lottie
    _lottieController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    // WAJIB! Hancurkan semua mesin saat halaman ditutup agar tidak terjadi Memory Leak
    _spinController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === EXPLICIT ANIMATION: BINTANG BERPUTAR ===
            const Text(
              "Explicit Animation (Putaran Tanpa Henti):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // AnimatedBuilder menggambar ulang dirinya 60 kali/detik mengikuti putaran Controller
            AnimatedBuilder(
              animation: _spinController,
              builder: (context, child) {
                return Transform.rotate(
                  // _spinController.value bergerak dari 0.0 sampai 1.0. 
                  // Dikalikan 6.2831853 (2 * Pi) karena rotasi Flutter menggunakan radian.
                  angle: _spinController.value * 6.2831853,
                  child: child, // Mengacu ke Icon di bawah agar tidak ikut di-rebuild secara konstan
                );
              },
              child: const Icon(Icons.star, size: 100, color: Colors.orange),
            ),

            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 50),

            // === STEP 4: INTEGRASI LOTTIE ANIMATION ===
            const Text(
              "Lottie Integration (Animasi Desainer):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
              width: 150,
              height: 150,
              controller: _lottieController, // Daftarkan controller
              onLoaded: (composition) {
                // Menyesuaikan durasi controller dengan durasi asli file json dari desainer
                _lottieController.duration = composition.duration;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Row untuk menampung dua tombol berdampingan (Tugas Mandiri 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _lottieController.reset();   // Kembalikan waktu animasi ke detik 0
                    _lottieController.forward(); // Jalankan maju sampai selesai
                  },
                  child: const Text("Mainkan Animasi Ceklis"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Tombol Merah
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _lottieController.reverse(); // Memutar mundur waktu animasi
                  },
                  child: const Text("Putar Mundur"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}