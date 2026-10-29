import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Pencarian live di seluruh produk.
class CariTab extends StatefulWidget {
  const CariTab({super.key});
  @override
  State<CariTab> createState() => _CariTabState();
}

class _CariTabState extends State<CariTab> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final hasil = daftarItem
        .where((i) => i.name.toLowerCase().contains(_q.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: hasil.isEmpty
              ? const Center(child: Text('Produk tidak ditemukan'))
              : ListView.builder(
                  itemCount: hasil.length,
                  itemBuilder: (context, i) {
                    final item = hasil[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: warnaItem(item),
                        child: Text(item.emoji),
                      ),
                      title: Text(item.name),
                      subtitle: Text('${item.category} • ${rupiah(item.price)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          app.tambah(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${item.name} ditambahkan'),
                                duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                      onTap: () => Navigator.pushNamed(context, '/detail',
                          arguments: item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
