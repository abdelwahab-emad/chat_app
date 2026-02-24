import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isMe});

  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? const Color(skprimaryColor) : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? Radius.zero : const Radius.circular(16),
              bottomRight: isMe ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
