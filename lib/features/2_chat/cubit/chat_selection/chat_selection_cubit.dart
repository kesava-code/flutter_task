// File: lib/features/2_chat/cubit/chat_selection/chat_selection_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/domain/entities/chat_room_entity.dart';
import 'chat_selection_state.dart';

class ChatSelectionCubit extends Cubit<ChatSelectionState> {
  ChatSelectionCubit() : super(const ChatSelectionState());

  void selectChat(ChatRoomEntity chatRoom) {
    emit(ChatSelectionState(selectedChatRoom: chatRoom));
  }

  void clearSelection() {
    emit(const ChatSelectionState());
  }
}
