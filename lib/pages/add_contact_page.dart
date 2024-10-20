import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addContact() async {
    // Validar los campos
    if (_nameController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese el nombre, número y correo'),
        ),
      );
      return;
    }

    try {
      // Agregar contacto a Firestore
      await _firestore.collection('contacts').add({
        'name': _nameController.text,
        'number': _numberController.text,
        'email': _emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Limpiar los campos de entrada
      _nameController.clear();
      _numberController.clear();
      _emailController.clear();

      // Mostrar snackbar de confirmación
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacto añadido')),
      );

      // Regresar a la pantalla anterior
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir contacto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir contacto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NOMBRE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del contacto',
                hintText: 'Ingresa el nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.purple[50],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'NÚMERO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: 'Número de contacto',
                hintText: 'Ingresa el número',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.purple[50],
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            const Text(
              'CORREO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo del contacto',
                hintText: 'Ingresa el correo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.purple[50],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addContact, // Llama a la función para añadir contacto
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Añadir Contacto'),
            ),
          ],
        ),
      ),
    );
  }
}
