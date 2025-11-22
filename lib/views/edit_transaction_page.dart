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

  String _selectedMethod = "Langsung";
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
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
        id: widget.transaction.id,
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

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Transaksi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Pembelian: ${widget.transaction.medicineName}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: "Jumlah Pembelian",
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Wajib diisi";
                  if (int.tryParse(val) == null || int.parse(val) <= 0)
                    return "Harus angka positif";
                  return null;
                },
              ),

              const SizedBox(height: 10),
              const Text(
                "Metode Pembelian:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: const Text("Pembelian Langsung"),
                value: "Langsung",
                groupValue: _selectedMethod,
                onChanged: (val) =>
                    setState(() => _selectedMethod = val.toString()),
              ),
              RadioListTile(
                title: const Text("Pembelian dengan Resep Dokter"),
                value: "Resep Dokter",
                groupValue: _selectedMethod,
                onChanged: (val) =>
                    setState(() => _selectedMethod = val.toString()),
              ),

              if (_selectedMethod == "Resep Dokter")
                TextFormField(
                  controller: _recipeController,
                  decoration: const InputDecoration(
                    labelText: "Nomor Resep Dokter",
                    hintText: "Min. 6 karakter (Huruf & Angka)",
                  ),
                  validator: (val) {
                    if (_selectedMethod == "Resep Dokter") {
                      if (val == null || val.length < 6)
                        return "Minimal 6 karakter";
                      bool hasLetter = val.contains(RegExp(r'[a-zA-Z]'));
                      bool hasDigit = val.contains(RegExp(r'[0-9]'));
                      if (!hasLetter || !hasDigit)
                        return "Harus kombinasi huruf & angka";
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Total Biaya: ${currencyFormatter.format(_totalPrice)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("BATAL"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text("SIMPAN"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
