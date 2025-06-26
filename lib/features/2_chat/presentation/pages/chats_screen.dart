// File: lib/features/2_chat/presentation/pages/chats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_state.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_selection/chat_selection_cubit.dart';
import 'package:flutter_task/features/2_chat/data/repositories/chat_repository_impl.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatSelectionCubit = context.watch<ChatSelectionCubit>();
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return BlocProvider(
      create: (_) => ChatListCubit(ChatRepositoryImpl()),
      child: BlocBuilder<ChatListCubit, ChatListState>(
        builder: (context, state) {
          if (state.status == ChatListStatus.initial || state.status == ChatListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ChatListStatus.failure) {
            return const Center(child: Text('Failed to load chats.\nCheck console for errors.'));
          }
          if (state.chatRooms.isEmpty) {
            return const Center(child: Text('No chats yet. Scan a QR code to start!'));
          }
          return ListView.builder(
            itemCount: state.chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = state.chatRooms[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(chatRoom.partnerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(chatRoom.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(DateFormat.jm().format(chatRoom.lastMessageTimestamp)),
                onTap: () {
                  if(isLargeScreen) {
                    chatSelectionCubit.selectChat(chatRoom);
                  } else {
                    // Pass the partner name as an extra parameter for the AppBar title
                    context.push('/chats/${chatRoom.id}', extra: chatRoom.partnerName);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
