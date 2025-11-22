import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../controllers/database_helper.dart';
import 'history_page.dart';

class PurchasePage extends StatefulWidget {
  final User user;
  final String medicineName;
  final int price;

  const PurchasePage({
    super.key,
    required this.user,
    required this.medicineName,
    required this.price,
  });

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  final _recipeController = TextEditingController();

  String _selectedMethod = "Langsung";
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _qtyController.addListener(_updateTotal);
  }

  void _updateTotal() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    setState(() {
      _totalPrice = qty * widget.price;
    });
  }

  void _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      TransactionModel transaction = TransactionModel(
        username: widget.user.username,
        medicineName: widget.medicineName,
        price: widget.price,
        quantity: int.parse(_qtyController.text),
        totalPrice: _totalPrice,
        date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        type: _selectedMethod,
        recipeNumber: _selectedMethod == "Resep Dokter"
            ? _recipeController.text
            : null,
      );

      await DatabaseHelper.instance.insertTransaction(transaction);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaksi Berhasil!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryPage(user: widget.user),
          ),
        );
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
      appBar: AppBar(title: const Text("Formulir Pembelian")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Obat
              Center(
                child: Text(
                  "Obat: ${widget.medicineName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Harga Satuan: ${currencyFormatter.format(widget.price)}",
                ),
              ),
              const Divider(),

              // Input Jumlah
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

              // Input Catatan
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Catatan Tambahan (Opsional)",
                ),
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
                        return "Minimal 6 karakter"; //
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTransaction,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("KONFIRMASI PEMBELIAN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
