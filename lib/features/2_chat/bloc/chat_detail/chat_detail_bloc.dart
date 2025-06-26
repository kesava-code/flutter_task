// File: lib/features/2_chat/bloc/chat_detail/chat_detail_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task/features/2_chat/domain/entities/message_entity.dart';
import 'package:flutter_task/features/2_chat/domain/repositories/chat_repository.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository _chatRepository;
  final String chatId;
  StreamSubscription? _messagesSubscription;

  ChatDetailBloc(this._chatRepository, this.chatId)
      : super(const ChatDetailState()) {
    on<MessageSent>(_onMessageSent);
    on<_MessagesUpdated>(_onMessagesUpdated);

    _messagesSubscription = _chatRepository.getMessages(chatId).listen((messages) {
      add(_MessagesUpdated(messages));
    }, onError: (_) {
       emit(state.copyWith(status: ChatDetailStatus.failure));
    });
  }

  void _onMessageSent(MessageSent event, Emitter<ChatDetailState> emit) async {
    await _chatRepository.sendMessage(chatRoomId: chatId, text: event.text);
  }

  void _onMessagesUpdated(_MessagesUpdated event, Emitter<ChatDetailState> emit) {
    // **THE FIX IS HERE:**
    // Every time new messages arrive, we try to mark them as seen.
    _chatRepository.markMessagesAsSeen(chatId);
    emit(state.copyWith(status: ChatDetailStatus.success, messages: event.messages));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
