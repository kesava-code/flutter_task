// File: lib/features/2_chat/presentation/pages/chat_detail_screen.dart
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with...'), // We'll get the user's name later
      ),
      body: Center(
        child: Text('Chat messages for room: $chatId will be here.'),
      ),
    );
  }
}
// TODO Implement this library.
