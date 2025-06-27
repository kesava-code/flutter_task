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
    on<ChatOpened>(_onChatOpened);

    // Trigger the initial "mark as seen" when the chat is first opened.
    add(ChatOpened());

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
    // Every time new messages arrive, we try to mark them as seen.
    // This ensures that if the user is already on the screen, the status updates live.
    _chatRepository.markMessagesAsSeen(chatId);
    emit(state.copyWith(status: ChatDetailStatus.success, messages: event.messages));
  }

  void _onChatOpened(ChatOpened event, Emitter<ChatDetailState> emit) async {
    // This is also called once when the chat screen is opened to clear any existing unread messages.
    await _chatRepository.markMessagesAsSeen(chatId);
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}