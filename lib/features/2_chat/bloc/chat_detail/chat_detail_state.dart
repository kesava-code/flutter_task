// File: lib/features/2_chat/bloc/chat_detail/chat_detail_state.dart
part of 'chat_detail_bloc.dart';

enum ChatDetailStatus { initial, loading, success, failure }

class ChatDetailState extends Equatable {
  final ChatDetailStatus status;
  final List<MessageEntity> messages;

  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.messages = const [],
  });

  ChatDetailState copyWith({
    ChatDetailStatus? status,
    List<MessageEntity>? messages,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [status, messages];
}
