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
import 'pages/chat_page.dart';

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
                  ),
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
          child:
              const Icon(Icons.person, color: Colors.white), // Icono de usuario
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
      ),
    );
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
        title: const Text('Configuraciones de Timogram'),
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
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Configuración de $title seleccionada')),
          );
        },
      ),
    );
  }
}

//pantalla de chat

class ChatPage extends StatefulWidget {
  final String userName;

  const ChatPage({super.key, required this.userName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  final _scrollController = ScrollController();

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    FirebaseFirestore.instance.collection('messages').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': currentUser!.uid,
      'userName': widget.userName,
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'] == currentUser!.uid,
                    chatDocs[index]['userName'],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.purple[50],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.purple,
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//chat bubble

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;

  const MessageBubble(this.message, this.isMe, this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.purple[200] : Colors.purple[100],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
