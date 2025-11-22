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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(user: widget.user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text(
                      "Riwayat",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: widget.user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person),
                    label: const Text(
                      "Profil",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Rekomendasi Obat :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final obat = medicines[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 4, 63, 192),
                          width: double.infinity,
                          child: const Icon(
                            Icons.medication_liquid_rounded,
                            size: 50,
                            color: Color.fromARGB(255, 207, 253, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              obat['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              obat['category'],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 13,
                              ),
                            ),
                            Center(
                              child: Text(
                                currencyFormatter.format(obat['price']),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 170, 23, 175),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    85,
                                    231,
                                    0,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PurchasePage(
                                        user: widget.user,
                                        medicineName: obat['name'],
                                        price: obat['price'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Beli",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
