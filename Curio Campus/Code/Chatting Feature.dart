import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  // Reference to the Firestore collection where messages are stored
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    // Add the message to the Firestore database
    _messagesCollection.add({
      'text': _controller.text,
      'createdAt': Timestamp.now(), // Store the message creation timestamp
      'isMe': true, // True indicates this message is from the current user
    });

    // Clear the input field after sending the message
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Feature'),
      ),
      body: Column(
        children: <Widget>[
          // Expanded widget to display the list of messages from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('createdAt', descending: true) // Order by time
                  .snapshots(), // Listen to real-time updates
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Get the list of documents (messages)
                var documents = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var messageData = documents[index].data() as Map<String, dynamic>;
                    return _MessageBubble(
                      text: messageData['text'],
                      isMe: messageData['isMe'],
                    );
                  },
                );
              },
            ),
          ),
          // Text input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                // Text input for message
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage, // Send the message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying individual message bubbles
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const _MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = isMe ? Colors.blue[200] : Colors.grey[300];
    final textColor = isMe ? Colors.black : Colors.black;

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
