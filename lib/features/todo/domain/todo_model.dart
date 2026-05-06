import 'package:isar/isar.dart';

// WAJIB: Jalankan 'flutter pub run build_runner build' setelah file ini diubah
part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;

  // Menampung deskripsi produk dari API
  // Gunakan String? (nullable) agar fleksibel
  String? description;

  // URL Gambar produk dari API[cite: 4]
  String? imageUrl; 

  // LOGIKA PERSONAL NIM 20123005: Menyimpan waktu saat bookmark ditekan
  // Dibuat nullable agar tidak error saat membaca data
  DateTime? createdAt; 

  // Status penyelesaian todo
  bool isCompleted = false;
}