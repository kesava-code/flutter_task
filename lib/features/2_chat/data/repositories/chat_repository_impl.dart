// File: lib/features/2_chat/data/repositories/chat_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/features/2_chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ChatRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<String> createChatRoom({required String partnerUid}) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    final currentUid = currentUser.uid;

    // Create a unique chat room ID by combining user UIDs in a consistent order
    List<String> participants = [currentUid, partnerUid];
    participants.sort();
    String chatRoomId = participants.join('_');

    final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);
    final doc = await chatRoomRef.get();

    // If the chat room doesn't exist, create it
    if (!doc.exists) {
      await chatRoomRef.set({
        'participants': participants,
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }
}