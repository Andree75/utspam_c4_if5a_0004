import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../controllers/database_helper.dart';
import 'edit_transaction_page.dart';

class DetailTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const DetailTransactionPage({super.key, required this.transaction});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  late TransactionModel currentTransaction;

  @override
  void initState() {
    super.initState();
    currentTransaction = widget.transaction;
  }

  void _deleteTransaction() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Transaksi?"),
        content: const Text("Data akan hilang permanen dari riwayat."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteTransaction(
                currentTransaction.id!,
              ); // [cite: 205]
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Transaksi berhasil dihapus")),
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTransactionPage(transaction: currentTransaction),
      ),
    );

    if (result != null && result is TransactionModel) {
      setState(() {
        currentTransaction = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    currentTransaction.medicineName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                _buildRow("ID Transaksi", "#${currentTransaction.id}"),
                _buildRow("Tanggal", currentTransaction.date),
                _buildRow("Pembeli", currentTransaction.username),
                const Divider(),
                _buildRow(
                  "Harga Satuan",
                  currencyFormatter.format(currentTransaction.price),
                ),
                _buildRow("Jumlah Beli", "${currentTransaction.quantity}"),
                _buildRow("Metode", currentTransaction.type),
                if (currentTransaction.recipeNumber != null)
                  _buildRow("Nomor Resep", currentTransaction.recipeNumber!),

                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.deepOrange[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL HARGA",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(currentTransaction.totalPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: _deleteTransaction,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                        onPressed: _editTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
