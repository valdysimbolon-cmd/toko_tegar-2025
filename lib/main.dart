import 'package:flutter/material.dart';
import 'pages/register_page.dart';
import 'latihan_tambahan/pages/detail_page.dart' as tb;
import 'latihan_tambahan/pages/checkout_page.dart' as tb;

void main() => runApp(const TokoTegarApp());

class TokoTegarApp extends StatelessWidget {
  const TokoTegarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Tegar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RegisterPage(),
      // Rute untuk fitur tambahan (detail produk dan checkout)
      routes: {
        '/detail': (_) => const tb.DetailPage(),
        '/checkout': (_) => const tb.CheckoutPage(),
      },
    );
  }
}