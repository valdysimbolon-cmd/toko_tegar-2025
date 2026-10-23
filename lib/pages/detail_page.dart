import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/products.dart';
import '../widgets/app_nav.dart';
import '../widgets/product_image.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  Future<void> _orderWhatsApp(BuildContext context) async {
    final pesan =
        'Halo, saya ingin memesan ${product.name} (${rp(product.price)})';
    final uri = Uri.parse(
        'https://wa.me/$waNumber?text=${Uri.encodeComponent(pesan)}');
    bool ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const merah = Color(0xFFC62828);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 20)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: merah, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ProductImage(product: product, height: 200, emojiSize: 80),
            const SizedBox(height: 12),
            Text(rp(product.price),
                style: const TextStyle(
                    color: merah, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _orderWhatsApp(context),
              icon: const Icon(Icons.chat),
              label: const Text('Order via WhatsApp'),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          AppNav(index: 0, onTap: (_) => Navigator.pop(context)),
    );
  }
}
