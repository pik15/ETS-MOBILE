import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background lembut sesuai style Todo
      appBar: AppBar(
        title: const Text('Katalog UTDI', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent, // Warna biru sesuai style Todo
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductCubit>().fetchProducts(),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Menu Praktikum',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('Muhamad Taupik Anjana', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.currency_bitcoin, color: Colors.orange),
              title: const Text('Live Crypto'),
              onTap: () {
                Navigator.pop(context);
                context.push('/crypto');
              },
            ),
            ListTile(
              leading: const Icon(Icons.android, color: Colors.green),
              title: const Text('Fitur Native'),
              onTap: () {
                Navigator.pop(context);
                context.push('/native');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.storage, color: Colors.blueAccent),
              title: const Text('Todo Isar'),
              onTap: () {
                Navigator.pop(context);
                context.push('/todo');
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        icon: const Icon(Icons.show_chart, color: Colors.white),
        label: const Text('Live Crypto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent,
      ),

      body: Column(
        children: [
          // Header dekorasi melengkung sesuai style TodoPage
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Text(
                'Daftar Produk Terbaru',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => context.read<ProductCubit>().fetchProducts(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductLoaded) {
                  final products = state.products;
                  if (products.isEmpty) {
                    return const Center(child: Text('Tidak ada produk tersedia.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 80),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('ID: ${item.id}', style: TextStyle(color: Colors.grey[600])),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
                          onTap: () => context.push('/detail/${item.id}'),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}