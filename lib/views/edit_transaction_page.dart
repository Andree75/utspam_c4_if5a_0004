import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../controllers/database_helper.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _qtyController;
  late TextEditingController _recipeController;

  // Kita tidak mengedit nama obat/harga satuan, hanya detail pembelian
  String _selectedMethod = "Langsung";
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data lama
    _qtyController = TextEditingController(
      text: widget.transaction.quantity.toString(),
    );
    _recipeController = TextEditingController(
      text: widget.transaction.recipeNumber ?? "",
    );
    _selectedMethod = widget.transaction.type;
    _totalPrice = widget.transaction.totalPrice;

    _qtyController.addListener(_updateTotal);
  }

  void _updateTotal() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    setState(() {
      _totalPrice = qty * widget.transaction.price;
    });
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      TransactionModel updatedTransaction = TransactionModel(
        id: widget.transaction.id, // ID Tetap
        username: widget.transaction.username,
        medicineName: widget.transaction.medicineName,
        price: widget.transaction.price,
        quantity: int.parse(_qtyController.text),
        totalPrice: _totalPrice,
        date: widget.transaction.date,
        type: _selectedMethod,
        recipeNumber: _selectedMethod == "Resep Dokter"
            ? _recipeController.text
            : null,
      );

      await DatabaseHelper.instance.updateTransaction(updatedTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi Berhasil Diperbarui!')),
        );
        Navigator.pop(context, updatedTransaction);
      }
    }
  }
