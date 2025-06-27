// File: lib/features/2_chat/data/repositories/chat_repository_impl.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task/features/2_chat/domain/entities/chat_room_entity.dart';
import 'package:flutter_task/features/2_chat/domain/entities/message_entity.dart';
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

    List<String> participants = [currentUid, partnerUid];
    participants.sort();
    String chatRoomId = participants.join('_');

    final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);
    final doc = await chatRoomRef.get();

    if (!doc.exists) {
      await chatRoomRef.set({
        'participants': participants,
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    }
    return chatRoomId;
  }

  @override
  Stream<List<ChatRoomEntity>> getChatRooms() {
    final currentUid = _firebaseAuth.currentUser?.uid;
    if (currentUid == null) throw Exception('User not logged in');

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chatRooms = <ChatRoomEntity>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          final participants = List<String>.from(data['participants']);
          final partnerUid = participants.firstWhere((uid) => uid != currentUid, orElse: () => '');

          if (partnerUid.isEmpty) {
            if (kDebugMode) {
              print("Skipping chat room ${doc.id} due to missing partner UID.");
            }
            continue;
          }

          final userDoc = await _firestore.collection('users').doc(partnerUid).get();
          if (!userDoc.exists) {
            if (kDebugMode) {
              print("Skipping chat room ${doc.id} because partner user $partnerUid does not exist.");
            }
            continue;
          }

          final partnerName = userDoc.data()?['displayName'] ?? 'Unknown User';
          final lastTimestamp = data['lastMessageTimestamp'] as Timestamp? ?? Timestamp.now();

          final unreadMessagesSnapshot = await _firestore
              .collection('chats')
              .doc(doc.id)
              .collection('messages')
              .where('senderId', isNotEqualTo: currentUid)
              .where('status', isEqualTo: 'sent')
              .count()
              .get();
          final unreadCount = unreadMessagesSnapshot.count ?? 0;

          chatRooms.add(ChatRoomEntity(
            id: doc.id,
            partnerName: partnerName,
            partnerUid: partnerUid,
            lastMessage: data['lastMessage'] ?? '',
            lastMessageTimestamp: lastTimestamp.toDate(),
            unreadCount: unreadCount,
          ));
        } catch (e) {
          if (kDebugMode) {
            print("Error processing chat document ${doc.id}: $e");
          }
        }
      }
      return chatRooms;
    });
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final statusString = data['status'] as String? ?? 'sent';
        return MessageEntity(
          id: doc.id,
          senderId: data['senderId'],
          text: data['text'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          status: MessageStatus.values.firstWhere((e) => e.name == statusString, orElse: () => MessageStatus.sent),
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage({required String chatRoomId, required String text}) async {
    final currentUid = _firebaseAuth.currentUser?.uid;
    if (currentUid == null) throw Exception('User not logged in');

    final now = DateTime.now();
    final messageData = {
      'senderId': currentUid,
      'text': text,
      'timestamp': Timestamp.fromDate(now),
      'status': 'sent',
    };

    await _firestore.collection('chats').doc(chatRoomId).collection('messages').add(messageData);
    await _firestore.collection('chats').doc(chatRoomId).update({
      'lastMessage': text,
      'lastMessageTimestamp': Timestamp.fromDate(now),
    });
  }

  @override
  Future<void> markMessagesAsSeen(String chatRoomId) async {
    final currentUid = _firebaseAuth.currentUser?.uid;
    if (currentUid == null) return;

    final messagesQuery = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUid)
        .where('status', isEqualTo: 'sent')
        .get();

    if (messagesQuery.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (var doc in messagesQuery.docs) {
      batch.update(doc.reference, {'status': 'seen'});
    }

    final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);
    batch.update(chatRoomRef, {'lastReadTimestamp_${currentUid}': FieldValue.serverTimestamp()});

    await batch.commit();
  }
}
