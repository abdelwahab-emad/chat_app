import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/chat_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static String id = 'chat_page';
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage(
    String chatRoomId,
    String currentUserId,
    String friendId,
  ) async {
    final messageText = controller.text.trim();
    if (messageText.isEmpty) return;

    final messageData = {
      'senderId': currentUserId,
      'receiverId': friendId,
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    controller.clear();

    try {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final friendName = args['friendName'];
    final friendId = args['friendId'];
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatRoomId = getChatRoomId(currentUserId, friendId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
        iconTheme: const IconThemeData(color: Color(skprimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey.shade700),
            ),
            const SizedBox(width: 20),
            Text(
              friendName,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: docs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                color: Colors.grey.shade700,
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              friendName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Chat App',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    }

                    final data = docs[index - 1].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;

                    return ChatBubble(
                      message: data['message'] ?? '',
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputField(
            controller: controller,
            onSend: () => sendMessage(chatRoomId, currentUserId, friendId),
          ),
        ],
      ),
    );
  }
}
