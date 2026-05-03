import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_studio/features/todo/domain/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Isar? isar;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initIsar();
  }

  Future<void> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    // Membuka instance Isar secara aman
    isar = Isar.getInstance() ?? await Isar.open([TodoSchema], directory: dir.path);
    if (mounted) setState(() {}); 
  }

  Future<void> _addTodo() async {
    if (_controller.text.isEmpty || isar == null) return;

    // Menambahkan data dengan Logika Timestamp (NIM 20123005)
    final newTodo = Todo()
      ..title = _controller.text
      ..createdAt = DateTime.now();

    await isar!.writeTxn(() async {
      await isar!.todos.put(newTodo);
    });
    
    _controller.clear();
  }

  Future<void> _deleteTodo(int id) async {
    if (isar == null) return;
    await isar!.writeTxn(() async {
      await isar!.todos.delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Tasks (NIM 05)', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Input dengan Style Melengkung
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Apa yang ingin dikerjakan?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  mini: true,
                  onPressed: _addTodo,
                  backgroundColor: Colors.orangeAccent,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Daftar Todo Reaktif
          Expanded(
            child: isar == null
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<Todo>>(
                    stream: isar!.todos.where().watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Center(child: Text("Error memuat data"));
                      
                      final todos = snapshot.data ?? [];

                      if (todos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 10),
                              Text('Belum ada tugas hari ini', style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final item = todos[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 12,
                              ),
                              title: Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              // PERBAIKAN: Penanganan Null Safety untuk menghindari error LateInitialization
                              subtitle: Text(
                                item.createdAt != null 
                                  ? "Dibuat: ${item.createdAt!.hour.toString().padLeft(2, '0')}:${item.createdAt!.minute.toString().padLeft(2, '0')}"
                                  : "Waktu tidak tersedia",
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => _deleteTodo(item.id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}