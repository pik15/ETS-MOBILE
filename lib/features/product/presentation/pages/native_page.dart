import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});
  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  static const platform = MethodChannel('utd.ac.id/native_jembatan');
  String _batteryLevelText = "Belum dicek";
  int _batteryLevelInt = -1; // Menyimpan angka murni untuk logika UI

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevelInt = result;
        _batteryLevelText = 'Level Baterai: $result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevelInt = -1;
        _batteryLevelText = "Gagal mengambil baterai: '${e.message}'.";
      });
    }
  }

  Future<void> _showToast() async {
    await platform.invokeMethod('showToast', {"message": "Halo dari Flutter Native!"});
  }

  // Fungsi pembantu untuk memilih Ikon berdasarkan persentase
  IconData _getBatteryIcon() {
    if (_batteryLevelInt == -1) return Icons.battery_unknown;
    if (_batteryLevelInt >= 90) return Icons.battery_full;
    if (_batteryLevelInt >= 70) return Icons.battery_6_bar;
    if (_batteryLevelInt >= 50) return Icons.battery_4_bar;
    if (_batteryLevelInt >= 30) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  // Fungsi pembantu untuk memilih Warna berdasarkan persentase
  Color _getBatteryColor() {
    if (_batteryLevelInt == -1) return Colors.grey;
    if (_batteryLevelInt >= 30) return Colors.green;
    if (_batteryLevelInt >= 15) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modul 7: Native Features')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- VISUALISASI BATERAI ---
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _getBatteryIcon(),
                  size: 150,
                  color: _getBatteryColor(),
                ),
                // Menampilkan angka di dalam/dekat baterai jika sudah dicek
                if (_batteryLevelInt != -1)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '$_batteryLevelInt%',
                      style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _batteryLevelText, 
              style: const TextStyle(fontSize: 18, color: Colors.grey)
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _getBatteryLevel,
              icon: const Icon(Icons.refresh),
              label: const Text('Cek Baterai HP'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[50]),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _showToast,
              icon: const Icon(Icons.message),
              label: const Text('Tampilkan Toast Android'),
            ),
          ],
        ),
      ),
    );
  }
}