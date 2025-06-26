// File: lib/features/2_chat/cubit/chat_selection/chat_selection_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/2_chat/domain/entities/chat_room_entity.dart';

class ChatSelectionState extends Equatable {
  final ChatRoomEntity? selectedChatRoom;

  const ChatSelectionState({this.selectedChatRoom});

  @override
  List<Object?> get props => [selectedChatRoom];
}