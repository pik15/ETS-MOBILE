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
      backgroundColor: const Color(0xFFF8F9FA), // Grey yang lebih modern
      appBar: AppBar(
        title: const Text(
          'UTD Store Taupik',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<ProductCubit>().fetchAllProducts(),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () => context.push('/todo'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        icon: const Icon(Icons.auto_graph_rounded, color: Colors.white),
        label: const Text('Market Crypto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange[700],
        elevation: 4,
      ),
      body: Column(
        children: [
          // Banner Info Diskon
          _buildDiscountBanner(),
          
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildLoadingState();
                }
                if (state is ProductError) {
                  return _buildErrorState(context, state.message);
                }
                if (state is ProductLoaded) {
                  return _buildProductList(state.products);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Sub Widgets untuk Style yang lebih bersih ---

  Widget _buildDiscountBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueAccent, Color(0xFF1A73E8)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_offer_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'DAFTAR PRODUK [DISKON 10%]',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 3, color: Colors.blueAccent),
          const SizedBox(height: 25),
          Text(
            'Menunggu 5 Detik... (Digit NIM: 5)',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List products) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 80), // Padding bawah extra untuk FAB
      itemCount: products.length,
      itemBuilder: (context, index) {
        final item = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'prod_${item.id}',
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'ID: ${item.id} • Tersedia',
                  style: TextStyle(color: Colors.blueAccent[700], fontSize: 12),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_right_rounded, color: Colors.blueAccent),
              ),
              onTap: () => context.push('/detail/${item.id}'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader tetap menggunakan style Anda dengan sedikit perbaikan layout
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blueAccent, Color(0xFF1A73E8)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(backgroundColor: Colors.white, radius: 25, child: Icon(Icons.person, color: Colors.blueAccent)),
                SizedBox(height: 12),
                Text('UTD Store & Crypto', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Muhamad Taupik Anjana', style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          _drawerItem(Icons.home_rounded, 'Katalog Produk', Colors.blueAccent, () => Navigator.pop(context)),
          _drawerItem(Icons.currency_bitcoin_rounded, 'Live Crypto', Colors.orange, () {
            Navigator.pop(context);
            context.push('/crypto');
          }),
          _drawerItem(Icons.sensors_rounded, 'Fitur Native', Colors.green, () {
            Navigator.pop(context);
            context.push('/native');
          }),
          const Divider(indent: 20, endIndent: 20),
          _drawerItem(Icons.bookmarks_rounded, 'Bookmark (Isar)', Colors.purple, () {
            Navigator.pop(context);
            context.push('/todo');
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
  
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 70, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.read<ProductCubit>().fetchAllProducts(),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          )
        ],
      ),
    );
  }
}