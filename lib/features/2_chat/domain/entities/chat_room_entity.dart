// File: lib/features/2_chat/domain/entities/chat_room_entity.dart
import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final String id;
  final String partnerName;
  final String partnerUid;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount; // Add unread count

  const ChatRoomEntity({
    required this.id,
    required this.partnerName,
    required this.partnerUid,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [id, partnerName, partnerUid, lastMessage, lastMessageTimestamp, unreadCount];
}
