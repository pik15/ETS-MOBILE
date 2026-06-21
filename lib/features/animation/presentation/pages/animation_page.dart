import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _lottieController; 

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2), 
    );
    _spinController.repeat();

    _lottieController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
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
            
            AnimatedBuilder(
              animation: _spinController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinController.value * 6.2831853,
                  child: child, 
                );
              },
              child: const Icon(Icons.star, size: 100, color: Colors.orange),
            ),

            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 50),

            // === INTEGRASI LOTTIE ANIMATION ===
            const Text(
              "Lottie Integration (Animasi Desainer):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
              width: 150,
              height: 150,
              controller: _lottieController, 
              onLoaded: (composition) {
                _lottieController.duration = composition.duration;
              },
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _lottieController.reset();   
                    _lottieController.forward(); 
                  },
                  child: const Text("Mainkan Animasi Ceklis"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Perbaikan: Jika posisi ada di awal (0.0), lompat ke akhir (1.0) dulu baru mundur
                    if (_lottieController.value == 0.0) {
                      _lottieController.value = 1.0;
                    }
                    _lottieController.reverse(); 
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