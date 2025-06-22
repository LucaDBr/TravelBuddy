import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String message = '';
  File? selectedImage;

  User get user => FirebaseAuth.instance.currentUser!;

  Future<void> changePassword() async {
    try {
      await user.updatePassword(passwordController.text.trim());
      setState(() {
        message = '✅ Passwort erfolgreich geändert.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = '❌ Fehler: ${e.message}';
      });
    }
  }

  Future<void> updateDisplayName() async {
    try {
      await user.updateDisplayName(nameController.text.trim());
      await user.reload();
      setState(() {
        message = '✅ Name aktualisiert.';
      });
    } catch (e) {
      setState(() {
        message = '❌ Fehler beim Aktualisieren des Namens.';
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
      try {
        // Dies ist nur lokal – für echtes Update müsste man Firebase Storage + Hosting einbinden
        await user.updatePhotoURL(picked.path);
        await user.reload();
        setState(() {
          message = '✅ Profilbild aktualisiert (lokal).';
        });
      } catch (e) {
        setState(() {
          message = '❌ Fehler beim Aktualisieren des Profilbilds.';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = user.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF3B82F6);
    final isSuccess = message.startsWith('✅');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Sicherheit'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (message.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
              ),
            ),
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : (user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage('assets/icon/IconProfiilpicPlaceholder.png'))
                            as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: Icon(Icons.edit, size: 18, color: accentColor),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Anzeigename',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: updateDisplayName,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Namen speichern'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(45),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Neues Passwort',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: changePassword,
            icon: const Icon(Icons.lock_reset),
            label: const Text('Passwort ändern'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(45),
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('E-Mail'),
            subtitle: Text(user.email ?? '-'),
            leading: const Icon(Icons.email_outlined),
          ),
        ],
      ),
    );
  }
}
