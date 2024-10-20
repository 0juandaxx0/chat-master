// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/add_contact_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.purple[100]!,
        ),
      ),
      home: const LoginPage(), // Pantalla inicial de la app
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timogram'),
        backgroundColor: Colors.purple, // Cambiar el color de fondo del AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Acción del botón de edición
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Aumentar el padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear el contenido a la izquierda
          children: [
            const SearchBar(),
            const SizedBox(height: 20), // Espaciado más amplio
            const Text(
              'Usuarios',
              style: TextStyle(
                fontSize: 24, // Tamaño de fuente más grande
                fontWeight: FontWeight.bold, // Fuente en negrita
                color: Colors.purple, // Color de texto
              ),
            ),
            const SizedBox(height: 10), // Espaciado entre el título y la lista
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 10), // Padding vertical
                children: const [
                  UserTile(
                    name: 'Julian',
                    code: '123',
                    description: 'Chatea conmigo.',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de añadir contacto
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String name;
  final String code;
  final String description;

  const UserTile({
    super.key,
    required this.name,
    required this.code,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2, // Sombra para dar profundidad
        margin: const EdgeInsets.symmetric(vertical: 5), // Espaciado vertical
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple[100], // Color de fondo del avatar
            child: const Icon(Icons.person,
                color: Colors.white), // Icono de usuario
          ),
          title: Text(
            '$name ($code)',
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Negrita para el nombre
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: Colors.grey, // Color gris para la descripción
            ),
          ),
          trailing:
              const Icon(Icons.more_vert, color: Colors.purple), // Icono de más
          onTap: () {
            // Cuando se toca el ListTile, navega a la pantalla de chat.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(userName: name),
              ),
            );
          },
        ));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
      child: TextField(
        decoration: InputDecoration(
          filled: true, // Fondo relleno
          fillColor: Colors.purple[50], // Color de fondo del campo de texto
          prefixIcon: const Icon(Icons.search,
              color: Colors.purple), // Icono de búsqueda
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Sin borde
          ),
          hintText: 'Buscar',
          hintStyle: const TextStyle(
              color: Colors.grey), // Color del texto de sugerencia
          contentPadding: const EdgeInsets.all(16.0), // Padding interno
        ),
      ),
    );
  }
}

// Pantalla de Configuración
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones de UberChat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Header de perfil
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuraciones',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Daniel', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil')),
                    );
                  },
                  child: const Icon(Icons.person),
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 10), // Espacio entre el encabezado y las opciones
          const SettingsOptionTile(
            icon: Icons.notifications,
            title: 'Notificaciones',
            description:
                'Configura las preferencias de notificación para la app.',
          ),
          const SettingsOptionTile(
            icon: Icons.person_outline,
            title: 'Personalización',
            description: 'Ajusta la apariencia y el comportamiento de la app.',
          ),
          const SettingsOptionTile(
            icon: Icons.lock,
            title: 'Privacidad',
            description:
                'Gestiona tus configuraciones de privacidad y seguridad.',
          ),
          const SettingsOptionTile(
            icon: Icons.language,
            title: 'Idioma',
            description: 'Selecciona el idioma de la aplicación.',
          ),
          const SettingsOptionTile(
            icon: Icons.update,
            title: 'Actualizaciones',
            description: 'Mantente al tanto de las últimas actualizaciones.',
          ),
        ],
      ),
    );
  }
}

// Clase SettingsOptionTile personalizada
class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0), // Espaciado interno
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.purple[100], // Color de fondo
          child: Icon(icon, size: 28, color: Colors.purple), // Icono
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios), // Flecha hacia adelante
        onTap: () {
          // Acción al tocar el tile (puedes definir lo que hace)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Acción para $title')),
          );
        },
      ),
    );
  }
}

// Pantalla de añadir contacto
class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

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
                fontSize: 20, // Tamaño de fuente mayor
                color: Colors.purple, // Color atractivo
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del contacto',
                hintText: 'Ingresa el nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person), // Icono de persona
                filled: true, // Fondo del campo
                fillColor: Colors.purple[50], // Color de fondo suave
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'NÚMERO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Tamaño de fuente mayor
                color: Colors.purple, // Color atractivo
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Número de contacto',
                hintText: 'Ingresa el número',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.phone), // Icono de teléfono
                filled: true, // Fondo del campo
                fillColor: Colors.purple[50], // Color de fondo suave
              ),
              keyboardType:
                  TextInputType.phone, // Teclado para número de teléfono
            ),
            const SizedBox(height: 20),
            const Text(
              'CORREO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Tamaño de fuente mayor
                color: Colors.purple, // Color atractivo
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo del contacto',
                hintText: 'Ingresa el correo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email), // Icono de correo
                filled: true, // Fondo del campo
                fillColor: Colors.purple[50], // Color de fondo suave
              ),
              keyboardType:
                  TextInputType.emailAddress, // Teclado para correo electrónico
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addContact(
                  nameController.text,
                  numberController.text,
                  emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contacto añadido')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Color del botón
                foregroundColor: Colors.white, // Color del texto del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 12), // Padding del botón
              ),
              child: const Text('Añadir Contacto'), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}

void addContact(String name, String number, String email) {
  FirebaseFirestore.instance.collection('contacts').add({
    'name': name,
    'number': number,
    'email': email,
  }).then((value) {
    print("Contact Added");
  }).catchError((error) {
    print("Failed to add contact: $error");
  });
}

// Pantalla de Chat
class ChatPage extends StatefulWidget {
  final String userName; // El nombre del usuario con quien se está chateando.

  const ChatPage({super.key, required this.userName});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> messages = []; // Lista para almacenar mensajes.
  final TextEditingController _controller =
      TextEditingController(); // Controlador para el TextField.

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(_controller.text); // Agregar mensaje a la lista.
        _controller.clear(); // Limpiar el TextField.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.userName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index],
                  isSentByMe:
                      true, // Suponemos que todos los mensajes son enviados por el usuario actual
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      filled: true, // Color de fondo del campo de texto
                      fillColor: Colors.purple[50], // Color de fondo claro
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin bordes visibles
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _sendMessage, // Llamar a la función para enviar el mensaje.
                  color: Colors.purple, // Color del ícono de enviar
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Clase ChatBubble
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble(
      {super.key, required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15), // Bordes más redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra sutil
              blurRadius: 5,
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16, // Tamaño de fuente mayor
            color: isSentByMe ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }
}
