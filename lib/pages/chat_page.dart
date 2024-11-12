import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  String? _editingMessageId; // ID del mensaje en edición

  // Función para enviar un mensaje
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Si estamos editando un mensaje
    if (_editingMessageId != null) {
      FirebaseFirestore.instance
          .collection('messages')
          .doc(_editingMessageId)
          .update({
        'text': message,
        'isEdited': true,
      });
      setState(() {
        _editingMessageId = null; // Limpiamos el ID de mensaje en edición
      });
    } else {
      // Si estamos enviando un mensaje nuevo
      FirebaseFirestore.instance.collection('messages').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': currentUser!.uid,
        'userName': widget.userName,
        'isEdited': false,
      });
    }

    _messageController.clear();
    _scrollToBottom();
  }

  // Función para hacer scroll hasta el último mensaje
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Función para eliminar un mensaje
  void _deleteMessage(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  // Función para copiar un mensaje
  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensaje copiado')),
    );
  }

  // Función para mostrar el cuadro de diálogo con las opciones
  void _showMessageOptions(String messageId, String messageText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Opciones del mensaje"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copiar'),
                onTap: () {
                  _copyMessage(messageText);
                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  setState(() {
                    _editingMessageId =
                        messageId; // Establecemos el ID del mensaje a editar
                    _messageController.text =
                        messageText; // Cargamos el texto en el controlador
                  });
                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar'),
                onTap: () {
                  _deleteMessage(messageId);
                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                },
              ),
            ],
          ),
        );
      },
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
                    final messageId = message.id;
                    final messageText = message['text'];
                    final messageTimestamp = message['createdAt'];
                    final isMe = message['userId'] == currentUser!.uid;
                    return GestureDetector(
                      onLongPress: () {
                        // Mostrar las opciones al hacer long press en un mensaje
                        _showMessageOptions(messageId, messageText);
                      },
                      child: MessageBubble(
                        message: messageText,
                        isMe: isMe,
                        timestamp: messageTimestamp,
                      ),
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

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}
