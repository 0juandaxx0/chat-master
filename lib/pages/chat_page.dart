import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  final String contactId;

  ChatPage({required this.contactId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String? _editingMessageId;
  String? _editingMessageText;

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      if (_editingMessageId != null) {
        // Editando un mensaje existente
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(_editingMessageId)
            .update({
          'text': _controller.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _editingMessageId = null; // Limpiar la edición
        _editingMessageText = null;
      } else {
        // Enviando un nuevo mensaje
        await FirebaseFirestore.instance.collection('messages').add({
          'senderId': currentUser!.uid,
          'receiverId': widget.contactId,
          'text': _controller.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      _controller.clear();
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

  void _editMessage(String messageId, String messageText) {
    setState(() {
      _editingMessageId = messageId;
      _editingMessageText = messageText;
      _controller.text = messageText;
    });
  }

  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance.collection('messages').doc(messageId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat con ${widget.contactId}"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.yellow.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
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
                      bool isMine = message['senderId'] == currentUser!.uid;
                      return GestureDetector(
                        onLongPress: () async {
                          final action = await showModalBottomSheet<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.copy),
                                    title: Text('Copiar'),
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: message['text']));
                                      Navigator.pop(context, 'copy');
                                    },
                                  ),
                                  if (isMine) ...[
                                    ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Editar'),
                                      onTap: () {
                                        Navigator.pop(context, 'edit');
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Eliminar'),
                                      onTap: () {
                                        Navigator.pop(context, 'delete');
                                      },
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                          if (action == 'edit') {
                            _editMessage(message.id, message['text']);
                          } else if (action == 'delete') {
                            _deleteMessage(message.id);
                          }
                        },
                        child: Container(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.orange.shade200
                                      : Colors.yellow.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  message['text'],
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              Text(
                                message['timestamp'] != null
                                    ? (message['timestamp'] as Timestamp)
                                        .toDate()
                                        .toString()
                                    : '',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
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
                          hintText: _editingMessageId != null
                              ? "Editando mensaje..."
                              : "Escribe un mensaje..."),
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
      ),
    );
  }
}
