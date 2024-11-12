import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/push_nitificaciones_service.dart';
import 'package:intl/intl.dart'; // Import para formatear la hora
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/add_contact_page.dart';
import 'pages/chat_page.dart';
import 'package:flutter/services.dart';
// Para copiar al portapapeles

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.initializeApp();

  // Verifica si Firebase ya está inicializado
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("Firebase ya estaba inicializado: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.orange,
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(),
            const SizedBox(height: 20),
            const Text(
              'Usuarios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );
        },
        backgroundColor: Colors.orange,
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
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          '$name ($code)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.more_vert, color: Colors.orange),
        onTap: () {
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orange[50],
          prefixIcon: const Icon(Icons.search, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Buscar',
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.all(16.0),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
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
          const SizedBox(height: 10),
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
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.orange[100],
          child: Icon(icon, size: 28, color: Colors.orange),
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

// Pantalla de chat

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

  // Función para eliminar el mensaje
  void _deleteMessage(String messageId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mensaje'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este mensaje?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancelar
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirmar eliminación
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
    }
  }

  // Función para editar el mensaje
  void _editMessage(String messageId, String currentText) async {
    _messageController.text = currentText; // Coloca el texto actual en el campo

    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar mensaje'),
        content: TextField(
          controller: _messageController,
          decoration: const InputDecoration(hintText: 'Edita tu mensaje'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancelar edición
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final updatedText = _messageController.text.trim();
              if (updatedText.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('messages')
                    .doc(messageId)
                    .update({'text': updatedText});
              }
              Navigator.of(context).pop(true); // Confirmar edición
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Función para copiar al portapapeles
  void _copyMessage(String messageText) {
    Clipboard.setData(ClipboardData(text: messageText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensaje copiado al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.userName}'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message['text'],
                      isMe: message['userId'] == currentUser!.uid,
                      timestamp: message['createdAt'],
                      messageId: message.id,
                      onDelete: _deleteMessage,
                      onEdit: _editMessage,
                      onCopy: _copyMessage,
                    );
                  },
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp timestamp;
  final String messageId;
  final Function(String) onDelete;
  final Function(String, String) onEdit;
  final Function(String) onCopy;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.messageId,
    required this.onDelete,
    required this.onEdit,
    required this.onCopy,
  });

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Muestra el menú de opciones al mantener presionado
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar mensaje'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onEdit(messageId, message);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Eliminar mensaje'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onDelete(messageId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copiar mensaje'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onCopy(message);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isMe ? Colors.orange[300] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
