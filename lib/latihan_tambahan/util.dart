import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// GANTI dengan nomor WhatsApp Anda (format 62..., tanpa + dan tanpa 0 di depan)
const waNomor = '6281234567890';

/// 51900 -> "Rp51.900"
String rupiah(int v) =>
    'Rp${v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';

/// Membuka WhatsApp dengan pesan otomatis.
Future<void> kirimWa(BuildContext context, String pesan) async {
  final uri =
      Uri.parse('https://wa.me/$waNomor?text=${Uri.encodeComponent(pesan)}');
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
