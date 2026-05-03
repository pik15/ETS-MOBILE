import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('utd.ac.id/native_jembatan');
  String _statusMessage = "Siap Melakukan Pengecekan";
  int _batteryLevel = -1;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Animasi berputar terus-menerus
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = result;
        _statusMessage = result > 20 ? "Kondisi Baterai Sehat" : "Baterai Lemah! Segera Charge";
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevel = -1;
        _statusMessage = "Error: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Dark Navy
      appBar: AppBar(
        title: const Text('NATIVE DASHBOARD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildModernBatteryIndicator(),
                    const SizedBox(height: 40),
                    _buildInfoCard(),
                    const SizedBox(height: 40),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Muhamad Taupik Anjana', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('NIM 20123005', style: TextStyle(color: Colors.blueAccent.shade100, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernBatteryIndicator() {
    double progress = _batteryLevel == -1 ? 0.0 : _batteryLevel / 100.0;
    Color batteryColor = progress > 0.5 ? Colors.cyanAccent : (progress > 0.2 ? Colors.orangeAccent : Colors.redAccent);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow Ring
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: batteryColor.withOpacity(0.2), width: 10),
                boxShadow: [BoxShadow(color: batteryColor.withOpacity(0.1), blurRadius: 30, spreadRadius: 10)],
              ),
            ),
            // Progress Ring
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: Colors.white10,
                color: batteryColor,
              ),
            ),
            // Center Info
            Column(
              children: [
                Icon(_batteryLevel == -1 ? Icons.bolt_outlined : Icons.bolt, color: batteryColor, size: 50),
                Text(
                  _batteryLevel == -1 ? "--" : "$_batteryLevel%",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: batteryColor),
                ),
                const Text('CAPACITY', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _customButton(
            label: "SCAN HARDWARE",
            icon: Icons.sync,
            color: Colors.blueAccent,
            onPressed: _getBatteryLevel,
          ),
          const SizedBox(height: 15),
          _customButton(
            label: "NATIVE NOTIFICATION",
            icon: Icons.notifications_active,
            color: Colors.transparent,
            isOutlined: true,
            onPressed: () => platform.invokeMethod('showToast', {"message": "Sistem Native Oke!"}),
          ),
        ],
      ),
    );
  }

  Widget _customButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed, bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                side: const BorderSide(color: Colors.blueAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                shadowColor: color.withOpacity(0.5),
              ),
            ),
    );
  }
}