import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Kartu produk: Hero image, tombol favorit, tombol + (keranjang dengan badge).
class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final fav = app.isFav(item);
        final q = app.qty(item);
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: InkWell(
            // Named route + kirim data lewat arguments
            onTap: () =>
                Navigator.pushNamed(context, '/detail', arguments: item),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'item-${item.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              color: warnaItem(item),
                              alignment: Alignment.center,
                              child: Text(item.emoji,
                                  style: const TextStyle(fontSize: 56)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => app.toggleFav(item),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: fav ? Colors.red : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(rupiah(item.price),
                                style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => app.tambah(item),
                        child: Badge(
                          isLabelVisible: q > 0,
                          label: Text('$q'),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.green.shade700,
                            child: const Icon(Icons.add,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
