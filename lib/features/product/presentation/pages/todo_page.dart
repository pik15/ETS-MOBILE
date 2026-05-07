// lib/features/todo/presentation/pages/todo_page.dart
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../todo/data/isar_service.dart';
import '../../../todo/domain/todo_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Produk Favorit (NIM 05)',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Color(0xFF1A73E8)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Todo>>(
        stream: isarService.listenToBookmarks(), // Menggunakan stream reaktif[cite: 2]
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error memuat data"));
          }

          final todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Belum ada produk favorit', style: TextStyle(color: Colors.grey[500])),
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
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ExpansionTile(
                  // Menambahkan Gambar Produk di Samping Judul
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[100],
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                            )
                          : const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    "Simpan: ${item.createdAt?.hour.toString().padLeft(2, '0')}:${item.createdAt?.minute.toString().padLeft(2, '0')}", // Logika NIM
                    style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
                  ),
                  trailing: Checkbox(
                    activeColor: Colors.blueAccent,
                    value: item.isCompleted,
                    onChanged: (val) => isarService.toggleComplete(item.id, val!),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menampilkan gambar lebih besar saat detail dibuka[cite: 5]
                          if (item.imageUrl != null)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(item.imageUrl!, height: 150),
                              ),
                            ),
                          const SizedBox(height: 15),
                          Text(
                            "Deskripsi:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.description ?? "Tidak ada deskripsi",
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                          const Divider(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => isarService.deleteTodo(item.id),
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              label: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}