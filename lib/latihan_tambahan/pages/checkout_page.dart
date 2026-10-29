import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Checkout: ringkasan, alamat (validasi), metode bayar (SegmentedButton),
/// AlertDialog konfirmasi, kirim rincian ke WhatsApp.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamat = TextEditingController();
  String _metode = 'COD';

  @override
  void dispose() {
    _alamat.dispose();
    super.dispose();
  }

  String _ringkasan() {
    final b = StringBuffer('Pesanan ${app.profil.namaToko}\n');
    for (final e in app.isiKeranjang) {
      b.writeln('- ${e.key.name} x${e.value} = ${rupiah(e.key.price * e.value)}');
    }
    b.writeln('Total: ${rupiah(app.total)}');
    b.writeln('Bayar: $_metode');
    b.writeln('Alamat: ${_alamat.text.trim()}');
    return b.toString();
  }

  Future<void> _konfirmasi() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: Text('Total ${rupiah(app.total)} dengan pembayaran $_metode. Lanjutkan?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ya, Pesan')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    app.kosongkan();
    Navigator.popUntil(context, (r) => r.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('Terima kasih, pesanan berhasil dibuat!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final isi = app.isiKeranjang;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ringkasan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Divider(),
                      for (final e in isi)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text('${e.key.name} x${e.value}',
                                      style: const TextStyle(fontSize: 13))),
                              Text(rupiah(e.key.price * e.value)),
                            ],
                          ),
                        ),
                      const Divider(),
                      Row(
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(rupiah(app.total),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _alamat,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Alamat pengiriman',
                      border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Alamat wajib diisi'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Metode pembayaran'),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'COD', label: Text('COD')),
                  ButtonSegment(value: 'Transfer', label: Text('Transfer')),
                  ButtonSegment(value: 'E-Wallet', label: Text('E-Wallet')),
                ],
                selected: {_metode},
                onSelectionChanged: (s) => setState(() => _metode = s.first),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isi.isEmpty ? null : _konfirmasi,
                child: const Text('Konfirmasi Pesanan'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: isi.isEmpty
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) return;
                        kirimWa(context, _ringkasan());
                      },
                icon: const Icon(Icons.chat),
                label: const Text('Kirim Rincian via WhatsApp'),
              ),
            ],
          );
        },
      ),
    );
  }
}
