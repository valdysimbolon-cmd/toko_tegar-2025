import 'package:flutter/material.dart';
import '../data/products.dart';
import '../widgets/app_nav.dart';
import '../widgets/category_item.dart';
import '../widgets/promo_card.dart';
import 'category_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String storeName;
  const HomePage({super.key, required this.storeName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  static const _tabLabels = ['Home', 'Pencarian', 'Keranjang', 'Profil'];

  void _openCategory(HomeCategory c) {
    if (!c.active) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori ${c.title} segera hadir')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryPage(initialKey: c.key)),
    );
  }

  Widget _banner() {
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dikirim Besok',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('ke Pilih Lokasi  ⌄', style: TextStyle(fontSize: 11)),
            ],
          ),
          Spacer(),
          Text('🧑‍🌾🥕', style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }

  Widget _home() {
    final promo = products.where((p) => p.category == 'protein').take(2);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(widget.storeName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        // KOMPONEN WAJIB: deret ikon kategori (Wrap -> baris ke-2 berisi Protein)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth / 5;
            return Wrap(
              children: homeCategories
                  .map((cat) => CategoryItem(
                        category: cat,
                        width: w,
                        onTap: () => _openCategory(cat),
                      ))
                  .toList(),
            );
          }),
        ),
        const SizedBox(height: 12),
        // KOMPONEN BONUS: banner + "Lihat Lebih Banyak" + kartu produk
        _banner(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text('Lihat Lebih Banyak  ⌄',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final p in promo)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: PromoCard(
                      product: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailPage(product: p)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListTile(
            leading: const Icon(Icons.store),
            title: Text(widget.storeName),
          ),
        ),
      ),
      body: _tab == 0
          ? _home()
          : Center(child: Text('Halaman ${_tabLabels[_tab]}')),
      bottomNavigationBar:
          AppNav(index: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}
