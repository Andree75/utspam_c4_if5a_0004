import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'login_page.dart';
import 'purchase_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'category': 'Demam',
      'price': 15000,
      'image': 'assets/obat1.png',
    },
    {
      'name': 'Amoxicillin',
      'category': 'Antibiotik',
      'price': 25000,
      'image': 'assets/obat2.png',
    },
    {
      'name': 'Betadine',
      'category': 'Antiseptik',
      'price': 10000,
      'image': 'assets/obat3.png',
    },
    {
      'name': 'Vitamin C',
      'category': 'Vitamin',
      'price': 50000,
      'image': 'assets/obat4.png',
    },
  ];

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sistem Pembelian Obat", style: TextStyle(fontSize: 18)),
            Text(
              "Selamat Datang, ${widget.user.fullName}",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
