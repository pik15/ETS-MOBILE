import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;
  
  // UBAH MENJADI NULLABLE (?) agar tidak error saat membaca data lama
  String? imageUrl; 
  
  // LOGIKA PERSONAL NIM 20123005: Simpan waktu
  // UBAH MENJADI NULLABLE (?) untuk menghindari LateInitializationError
  DateTime? createdAt; 

  bool isCompleted = false;
}