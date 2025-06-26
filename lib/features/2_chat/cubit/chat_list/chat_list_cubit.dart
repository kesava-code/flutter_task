// File: lib/features/2_chat/cubit/chat_list/chat_list_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/domain/repositories/chat_repository.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _chatRoomsSubscription;

  ChatListCubit(this._chatRepository) : super(const ChatListState()) {
    emit(state.copyWith(status: ChatListStatus.loading));
    _chatRoomsSubscription = _chatRepository.getChatRooms().listen((chatRooms) {
      emit(state.copyWith(status: ChatListStatus.success, chatRooms: chatRooms));
    }, onError: (error) {
      print("ChatListCubit Error: $error"); // Log the error
      emit(state.copyWith(status: ChatListStatus.failure));
    });
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    return super.close();
  }
}
