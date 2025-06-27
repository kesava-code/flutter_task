// File: lib/features/2_chat/presentation/pages/chats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_list/chat_list_state.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_selection/chat_selection_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_task/l10n/app_localizations.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        if (state.status == ChatListStatus.initial || state.status == ChatListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ChatListStatus.failure) {
          return Center(child: Text(l10n.failedToLoadChats));
        }
        if (state.chatRooms.isEmpty) {
          return Center(child: Text(l10n.noChats));
        }
        return ListView.builder(
          itemCount: state.chatRooms.length,
          itemBuilder: (context, index) {
            final chatRoom = state.chatRooms[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(chatRoom.partnerName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(chatRoom.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat.jm().format(chatRoom.lastMessageTimestamp)),
                  if (chatRoom.unreadCount > 0) ...[
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        chatRoom.unreadCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () {
                if (isLargeScreen) {
                  context.read<ChatSelectionCubit>().selectChat(chatRoom);
                } else {
                  context.push('/chats/${chatRoom.id}', extra: chatRoom.partnerName);
                }
              },
            );
          },
        );
      },
    );
  }
}