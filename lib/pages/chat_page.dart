import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String contactId; // El ID del usuario con quien estás chateando

  ChatPage({required this.contactId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': currentUser!.uid, // ID del remitente (usuario actual)
        'receiverId': widget.contactId, // ID del receptor (contacto)
        'text': _controller.text, // Texto del mensaje
        'timestamp': FieldValue.serverTimestamp(), // Marca de tiempo
      });
      _controller.clear(); // Limpiar el campo de texto después de enviar
    }
  }

  Stream<QuerySnapshot> _messageStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId',
            isEqualTo: currentUser!.uid) // Mensajes para el usuario actual
        .where('senderId',
            isEqualTo: widget.contactId) // De este contacto específico
        .orderBy('timestamp',
            descending: true) // Ordenar por tiempo (más reciente primero)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat con ${widget.contactId}"),
      ),
      body: Column(
        children: [
          // Sección de mensajes
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text(message['text']),
                    );
                  },
                );
              },
            ),
          ),
          // Barra de texto para enviar mensajes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        InputDecoration(hintText: "Escribe un mensaje..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
