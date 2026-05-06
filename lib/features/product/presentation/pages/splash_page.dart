import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // LOGIKA NIM: Delay 5 detik sesuai digit terakhir NIM 20123005
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menyelaraskan dengan palet warna ProductPage (Gradien Biru Modern)[cite: 5, 7]
    const Color gradientStart = Color(0xFF448AFF); // Blue Accent
    const Color gradientEnd = Color(0xFF1A73E8);   // Darker Blue

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ),
        ),
        child: Stack(
          children: [
            // Dekorasi halus (Glassmorphism effect)
            Positioned(
              top: -50,
              left: -50,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO: Elemen Membulat yang Elegan
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // JUDUL: Tipografi Premium selaras dengan AppBar
                  const Text(
                    'UTD STORE',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const Text(
                    'MODERN RETAIL EXPERIENCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // PROGRESS: Linear Indicator Minimalis[cite: 5]
                  const SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      color: Colors.white,
                      minHeight: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // IDENTITAS: Muhamad Taupik Anjana 20123005
                  const Text(
                    'MUHAMAD TAUPIK ANJANA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'NIM: 20123005',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            
            // FOOTER: Kesan Eksklusif
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'v1.0 • PREMIUM EDITION',
                  style: TextStyle(
                    color: Colors.white24, 
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}