// File: lib/features/2_chat/domain/repositories/chat_repository.dart
import 'package:flutter_task/features/2_chat/domain/entities/chat_room_entity.dart';
import 'package:flutter_task/features/2_chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<String> createChatRoom({required String partnerUid});
  Stream<List<ChatRoomEntity>> getChatRooms();
  Stream<List<MessageEntity>> getMessages(String chatRoomId);
  Future<void> sendMessage({required String chatRoomId, required String text});
  Future<void> markMessagesAsSeen(String chatRoomId);
}
