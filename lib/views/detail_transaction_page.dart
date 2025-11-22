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
    // Konfirmasi Hapus
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

