import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Keranjang: tombol +/-, geser untuk hapus (Dismissible), total, Checkout.
class KeranjangTab extends StatelessWidget {
  const KeranjangTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final isi = app.isiKeranjang;
        if (isi.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Keranjang masih kosong'),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: isi.length,
                itemBuilder: (context, i) {
                  final item = isi[i].key;
                  final q = isi[i].value;
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      app.hapus(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} dihapus')),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: warnaItem(item),
                        child: Text(item.emoji),
                      ),
                      title: Text(item.name, style: const TextStyle(fontSize: 13)),
                      subtitle: Text(rupiah(item.price * q)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => app.kurang(item),
                              icon: const Icon(Icons.remove_circle_outline)),
                          Text('$q'),
                          IconButton(
                              onPressed: () => app.tambah(item),
                              icon: const Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${app.jumlah} barang',
                          style: const TextStyle(fontSize: 12)),
                      Text(rupiah(app.total),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/checkout'),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
