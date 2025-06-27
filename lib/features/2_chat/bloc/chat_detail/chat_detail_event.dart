part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
  @override
  List<Object> get props => [];
}

class MessageSent extends ChatDetailEvent {
  final String text;
  const MessageSent(this.text);
  @override
  List<Object> get props => [text];
}

// This event is triggered by the stream subscription
class _MessagesUpdated extends ChatDetailEvent {
  final List<MessageEntity> messages;
  const _MessagesUpdated(this.messages);
   @override
  List<Object> get props => [messages];
}

class ChatOpened extends ChatDetailEvent {}