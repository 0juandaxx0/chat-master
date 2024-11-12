import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  final String contactId;

  const ChatPage({super.key, required this.contactId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String? editingMessageId; // ID del mensaje en edición

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      if (editingMessageId != null) {
        // Editar mensaje
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(editingMessageId)
            .update({'text': _controller.text});
        setState(() {
          editingMessageId = null;
        });
      } else {
        // Enviar nuevo mensaje
        await FirebaseFirestore.instance.collection('messages').add({
          'senderId': currentUser!.uid,
          'receiverId': widget.contactId,
          'text': _controller.text,
          'timestamp': Timestamp.now(),
        });
      }
      _controller.clear();
    }
  }

  void _deleteMessage(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  void _editMessage(String messageId, String currentText) {
    setState(() {
      editingMessageId = messageId;
      _controller.text = currentText;
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensaje copiado')),
    );
  }

  Future<void> _pasteText() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      _controller.text = data.text ?? '';
    }
  }

  Stream<QuerySnapshot> _messageStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: currentUser!.uid)
        .where('senderId', isEqualTo: widget.contactId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat con ${widget.contactId}"),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == currentUser!.uid;
                    return GestureDetector(
                      onLongPress: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 0, 0),
                          items: [
                            PopupMenuItem(
                              value: 'copy',
                              child: const Text('Copiar'),
                            ),
                            if (isMe)
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text('Editar'),
                              ),
                            if (isMe)
                              PopupMenuItem(
                                value: 'delete',
                                child: const Text('Eliminar'),
                              ),
                          ],
                        ).then((value) {
                          if (value == 'copy') {
                            _copyMessage(message['text']);
                          } else if (value == 'edit') {
                            _editMessage(message.id, message['text']);
                          } else if (value == 'delete') {
                            _deleteMessage(message.id);
                          }
                        });
                      },
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color:
                                isMe ? Colors.orange[300] : Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message['text'],
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _formatTimestamp(message['timestamp']),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe un mensaje...",
                      filled: true,
                      fillColor: Colors.orange[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.paste, color: Colors.orange),
                  onPressed: _pasteText,
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
