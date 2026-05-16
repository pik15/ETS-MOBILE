import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart'; // Import const syncTask dari main.dart

class BackgroundSyncPage extends StatefulWidget {
  const BackgroundSyncPage({super.key});

  @override
  State<BackgroundSyncPage> createState() => _BackgroundSyncPageState();
}

class _BackgroundSyncPageState extends State<BackgroundSyncPage> {
  String _lastSyncInfo = "Belum pernah sinkronisasi";

  @override
  void initState() {
    super.initState();
    _cekWaktuSyncTerakhir();
  }

  // Fungsi untuk membaca memori lokal HP (SharedPreferences)
  Future<void> _cekWaktuSyncTerakhir() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSyncInfo = prefs.getString("last_sync_time") ?? "Belum pernah sinkronisasi";
    });
  }

  // Fungsi untuk Mendaftar Tugas Rutin (Mandat ke OS)
  void _mulaiSinkronisasiRutin() {
    Workmanager().registerPeriodicTask(
      "unique_id_sync_01", // ID unik tugas ini
      syncTask, // Nama tugas yang akan dicocokkan di dispatcher
      frequency: const Duration(minutes: 15), // Minimal 15 Menit (Aturan Android)
      constraints: Constraints(
        networkType: NetworkType.connected, // Hanya jalan jika ada internet
        requiresBatteryNotLow: true, // Jangan jalan jika baterai lemah
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auto-Sync Aktif! Tugas berjalan 15 menit lagi.")),
    );
  }

  // Fungsi untuk Membatalkan Tugas
  void _hentikanSinkronisasi() {
    Workmanager().cancelByUniqueName("unique_id_sync_01");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auto-Sync Dibatalkan!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Background')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sync, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 20),
              const Text(
                "Terakhir Dikerjakan Oleh Latar Belakang:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Menampilkan waktu dari SharedPreferences
              Text(
                _lastSyncInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, 
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _mulaiSinkronisasiRutin,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Mulai Auto-Sync'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _hentikanSinkronisasi,
                    icon: const Icon(Icons.stop),
                    label: const Text('Matikan'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Tombol untuk memuat ulang UI guna membaca data terbaru
              TextButton.icon(
                onPressed: _cekWaktuSyncTerakhir,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Tampilan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}