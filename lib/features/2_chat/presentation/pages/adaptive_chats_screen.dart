// File: lib/features/2_chat/presentation/pages/adaptive_chats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_selection/chat_selection_cubit.dart';
import 'package:flutter_task/features/2_chat/cubit/chat_selection/chat_selection_state.dart';
import 'package:flutter_task/features/2_chat/presentation/pages/chat_detail_screen.dart';
import 'package:flutter_task/features/2_chat/presentation/pages/chats_screen.dart';

class AdaptiveChatsScreen extends StatelessWidget {
  const AdaptiveChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatSelectionCubit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // For large screens, show master-detail view
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                SizedBox(
                  width: 300, // Width of the chat list
                  child: ChatsScreen(),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: BlocBuilder<ChatSelectionCubit, ChatSelectionState>(
                    builder: (context, state) {
                      if (state.selectedChatRoom != null) {
                        return ChatDetailScreen(
                          key: ValueKey(state.selectedChatRoom!.id), // Ensure it rebuilds on change
                          chatId: state.selectedChatRoom!.id,
                          partnerName: state.selectedChatRoom!.partnerName,
                        );
                      }
                      return const Center(
                        child: Text('Select a chat to view messages'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          // For small screens, just show the list
          return const ChatsScreen();
        },
      ),
    );
  }
}