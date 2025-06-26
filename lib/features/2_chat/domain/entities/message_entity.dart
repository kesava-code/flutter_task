// File: lib/features/2_chat/domain/entities/message_entity.dart
import 'package:equatable/equatable.dart';

enum MessageStatus { sent, seen }

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  @override
  List<Object?> get props => [id, senderId, text, timestamp, status];
}
