// File: lib/features/2_chat/cubit/chat_list/chat_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/2_chat/domain/entities/chat_room_entity.dart';

enum ChatListStatus { initial, loading, success, failure }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ChatRoomEntity> chatRooms;

  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chatRooms = const [],
  });

  ChatListState copyWith({
    ChatListStatus? status,
    List<ChatRoomEntity>? chatRooms,
  }) {
    return ChatListState(
      status: status ?? this.status,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }

  @override
  List<Object?> get props => [status, chatRooms];
}
