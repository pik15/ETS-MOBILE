import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/todo_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TodoSchema], // Skema dari build_runner
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // --- CREATE: Simpan Bookmark dengan Logika NIM 20123005 ---
  // Ditambahkan parameter 'description' sesuai syarat ETS
  Future<void> saveBookmark(Todo todo) async {
    final isar = await db;
    // Menggunakan writeTxnSync untuk operasi tulis database lokal
    isar.writeTxnSync(() => isar.todos.putSync(todo));
  }

  // --- UPDATE: Logika Selesai (Menu Selesai Todo) ---
  // Diperlukan untuk mengubah status isCompleted di UI[cite: 2]
  Future<void> toggleComplete(Id id, bool status) async {
    final isar = await db;
    final todo = await isar.todos.get(id); // Cari data berdasarkan ID[cite: 2]
    if (todo != null) {
      todo.isCompleted = status;
      isar.writeTxnSync(() => isar.todos.putSync(todo)); // Timpa data lama[cite: 2]
    }
  }

  // --- DELETE: Menghapus Bookmark[cite: 2] ---
  Future<void> deleteTodo(Id id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todos.deleteSync(id));
  }

  // --- READ & REACTIVE: Stream untuk UI Tanpa setState[cite: 2] ---
  Stream<List<Todo>> listenToBookmarks() async* {
    final isar = await db;
    // watch(fireImmediately: true) memastikan UI update instan saat data berubah[cite: 2]
    yield* isar.todos.where().watch(fireImmediately: true);
  }
}