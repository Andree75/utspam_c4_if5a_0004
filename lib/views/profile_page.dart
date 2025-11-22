import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Pengguna")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Column(
                children: [
                  _buildProfileItem(
                    Icons.person,
                    "Nama Lengkap",
                    user.fullName,
                  ),
                  const Divider(),
                  _buildProfileItem(Icons.email, "Email", user.email),
                  const Divider(),
                  _buildProfileItem(
                    Icons.phone,
                    "No. Telepon",
                    user.phoneNumber,
                  ),
                  const Divider(),
                  _buildProfileItem(Icons.home, "Alamat", user.address),
                  const Divider(),
                  _buildProfileItem(
                    Icons.account_circle,
                    "Username",
                    user.username,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 61, 194)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
