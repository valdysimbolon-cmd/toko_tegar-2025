import 'package:flutter/material.dart';
import '../data/products.dart';
import '../widgets/app_nav.dart';
import '../widgets/cart_bar.dart';
import '../widgets/category_item.dart';
import '../widgets/product_tile.dart';
import 'detail_page.dart';

/// Halaman daftar produk per kategori (wajib: Protein).
class CategoryPage extends StatefulWidget {
  final String initialKey; // kategori yang diklik di Home (dikirim via constructor)
  const CategoryPage({super.key, required this.initialKey});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String _key = widget.initialKey;
  String _query = '';
  int _chip = 1; // 0 = Filter, 1 = Semua, 2 = judul kategori, 3 = Baru (tampilan saja)

  @override
  Widget build(BuildContext context) {
    final cat = homeCategories.firstWhere((c) => c.key == _key);
    final list = products
        .where((p) => p.category == _key)
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    Widget chip(int i, String label) {
      final sel = _chip == i;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label, style: TextStyle(fontSize: 11, color: sel ? Colors.white : Colors.black)),
          selected: sel,
          showCheckmark: false,
          selectedColor: Colors.green.shade700,
          onSelected: (_) => setState(() => _chip = i),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Baris atas: tombol kembali + kolom pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Cari lebih banyak di Toko Tegar...',
                          prefixIcon: const Icon(Icons.search, size: 18),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Deret ikon kategori (yang aktif diberi border hijau)
            SizedBox(
              height: 84,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: homeCategories.length,
                itemBuilder: (context, i) {
                  final c = homeCategories[i];
                  return CategoryItem(
                    category: c,
                    width: 68,
                    selected: c.key == _key,
                    onTap: () {
                      if (c.active) setState(() => _key = c.key);
                    },
                  );
                },
              ),
            ),
            // Chip filter
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  chip(0, 'Filter'),
                  chip(1, 'Semua'),
                  chip(2, cat.title),
                  chip(3, 'Baru'),
                ],
              ),
            ),
            // Daftar produk (grid 3 kolom, lazy)
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: list.isEmpty
                          ? const Center(child: Text('Produk tidak ditemukan'))
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.55,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, i) => ProductTile(
                                product: list[i],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DetailPage(product: list[i])),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CartBar(),
          AppNav(index: 0, onTap: (_) => Navigator.pop(context)),
        ],
      ),
    );
  }
}
