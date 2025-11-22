import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../controllers/database_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      await DatabaseHelper.instance.registerUser(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Registrasi Pengguna"),
        backgroundColor: const Color.fromARGB(255, 255, 191, 52),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || !val.contains('@'))
                    return "Email tidak valid";
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Nomor Telepon"),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  // Validasi hanya angka
                  if (val == null || int.tryParse(val) == null)
                    return "Hanya boleh angka";
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat"),
                maxLines: 2,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) {
                  if (val == null || val.length < 6)
                    return "Minimal 6 karakter";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 255, 253, 141),
                ),
                child: const Text(
                  "DAFTAR",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const SizedBox(height: 7),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Sudah punya akun? Login disini",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
