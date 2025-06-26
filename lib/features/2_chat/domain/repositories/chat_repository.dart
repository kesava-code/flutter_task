// File: lib/features/2_chat/domain/repositories/chat_repository.dart

abstract class ChatRepository {
  Future<String> createChatRoom({required String partnerUid});
}
