import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;
  late String imageUrl; // Tambahkan ini untuk foto produk
  
  // LOGIKA PERSONAL NIM 20123005: Wajib simpan waktu
  late DateTime createdAt; 

  bool isCompleted = false;
}