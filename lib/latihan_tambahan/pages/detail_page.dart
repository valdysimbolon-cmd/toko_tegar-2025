import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Detail produk. Data diterima lewat Navigator arguments.
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          ListenableBuilder(
            listenable: app,
            builder: (context, _) => IconButton(
              onPressed: () => app.toggleFav(item),
              icon: Icon(
                app.isFav(item) ? Icons.favorite : Icons.favorite_border,
                color: app.isFav(item) ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'item-${item.id}',
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: warnaItem(item),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(item.emoji, style: const TextStyle(fontSize: 100)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(item.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(children: [
            Chip(label: Text(item.category)),
            const SizedBox(width: 8),
            Text('Stok: ${item.stok}',
                style: const TextStyle(color: Colors.red)),
          ]),
          Text(rupiah(item.price),
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC62828))),
          const SizedBox(height: 16),
          // Pemilih jumlah
          Row(
            children: [
              const Text('Jumlah'),
              const Spacer(),
              IconButton(
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_qty', style: const TextStyle(fontSize: 16)),
              IconButton(
                onPressed:
                    _qty < item.stok ? () => setState(() => _qty++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text('Subtotal: ${rupiah(item.price * _qty)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              app.tambah(item, _qty);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$_qty ${item.name} masuk keranjang')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Tambah ke Keranjang'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => kirimWa(context,
                'Halo, saya ingin memesan $_qty x ${item.name} (${rupiah(item.price * _qty)})'),
            icon: const Icon(Icons.chat),
            label: const Text('Order via WhatsApp'),
          ),
        ],
      ),
    );
  }
}
