// File: lib/features/2_chat/presentation/pages/chat_detail_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:flutter_task/features/2_chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_task/features/2_chat/domain/entities/message_entity.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  final String? partnerName; // Made optional for adaptive UI
  const ChatDetailScreen({super.key, required this.chatId, this.partnerName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatDetailBloc(ChatRepositoryImpl(), chatId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(partnerName ?? 'Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
                builder: (context, state) {
                  if (state.status == ChatDetailStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),
            const MessageInputField(),
          ],
        ),
      ),
    );
  }
}

// MessageBubble and MessageInputField widgets remain the same as the previous version
class MessageBubble extends StatelessWidget {
    final MessageEntity message;
    const MessageBubble({super.key, required this.message});

    @override
    Widget build(BuildContext context) {
      final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;
      return Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.jm().format(message.timestamp), // Format the time
                      style: TextStyle(
                        fontSize: 10,
                        color: (isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondaryContainer).withOpacity(0.7),
                      ),
                    ),
                    if(isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.status == MessageStatus.seen ? Icons.done_all : Icons.done,
                        size: 14,
                        color: message.status == MessageStatus.seen
                          ? Colors.blue.shade300
                          : (isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondaryContainer).withOpacity(0.7),
                      )
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  class MessageInputField extends StatefulWidget {
    const MessageInputField({super.key});

    @override
    State<MessageInputField> createState() => _MessageInputFieldState();
  }

  class _MessageInputFieldState extends State<MessageInputField> {
    final _controller = TextEditingController();

    void _sendMessage() {
      if (_controller.text.trim().isNotEmpty) {
        context.read<ChatDetailBloc>().add(MessageSent(_controller.text.trim()));
        _controller.clear();
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      }
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Send a message...',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16)
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      );
    }
  }