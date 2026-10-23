import 'package:flutter/material.dart';
import '../data/products.dart';

/// Bar hijau "Lihat Keranjang" (komponen bonus).
class CartBar extends StatelessWidget {
  const CartBar({super.key});

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          final entries = cart.items.entries.toList();
          if (entries.isEmpty) {
            return const SizedBox(
                height: 120, child: Center(child: Text('Keranjang kosong')));
          }
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            children: [
              for (final e in entries)
                ListTile(
                  title: Text(e.key.name, style: const TextStyle(fontSize: 13)),
                  subtitle: Text('${e.value} x ${rp(e.key.price)}'),
                  trailing: Text(rp(e.key.price * e.value)),
                ),
              const Divider(),
              ListTile(
                title: const Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(rp(cart.total),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return GestureDetector(
          onTap: () => _showCart(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lihat Keranjang',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                    Text('${cart.count} Barang',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10)),
                  ],
                ),
                const Spacer(),
                Text(rp(cart.total),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
