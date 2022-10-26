import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/story_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constants.dart';

abstract class ChatRepository {
  Future<List<StoryEntity>> fetchStories();

  Future<List<RoomEntity>> fetchRooms(String uId);

  Future<RoomEntity> getRoomByChatUser(String uId, String chatUserId);

  Future<RoomEntity> getRoomById(String roomId);
}

class ChatRepositoryImpl extends ChatRepository {
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection(AppConstants.roomsKey);
  final UserRepository userRepository = UserRepositoryImpl();
  final AuthRepository authRepository = AuthRepositoryImpl();

  @override
  Future<List<StoryEntity>> fetchStories() async {
    final users =
        await userRepository.fetchUsersWithoutUid(authRepository.getUid());
    return users.map((e) => StoryEntity(user: e)).toList();
  }

  @override
  Future<List<RoomEntity>> fetchRooms(String uId) async {
    final roomDoc = await rooms.orderBy("updatedTime", descending: true).get();
    List<RoomEntity> result = [];
    for (var queryDocumentSnapshot in roomDoc.docs) {
      if ((queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
          .contains(uId)) {
        final List<UserEntity> participants = [];

        for (String participantId
            in queryDocumentSnapshot.get(AppConstants.participantsKey)) {
          UserEntity user = await userRepository.getUserById(participantId);
          participants.add(user);
        }
        final messagesCollection = await rooms
            .doc(queryDocumentSnapshot.id)
            .collection(AppConstants.messagesKey)
            .get();
        final List<MessageEntity> messages = messagesCollection.docs.map((e) {
          return MessageEntity.fromJson(e.data()).copyWith(messageId: e.id);
        }).toList();
        result.add(RoomEntity(
            roomId: queryDocumentSnapshot.id,
            messages: messages,
            participants: participants));
      }
    }
    return result;
  }

  @override
  Future<RoomEntity> getRoomById(String roomId) async {
    final roomDoc = await rooms.doc(roomId).get();
    final List<UserEntity> participants = [];
    for (String participantId in roomDoc.get(AppConstants.participantsKey)) {
      UserEntity user = await userRepository.getUserById(participantId);
      participants.add(user);
    }
    final messagesCollection =
        await rooms.doc(roomDoc.id).collection(AppConstants.messagesKey).get();
    final List<MessageEntity> messages = messagesCollection.docs.map((e) {
      return MessageEntity.fromJson(e.data()).copyWith(messageId: e.id);
    }).toList();

    return RoomEntity(
        roomId: roomDoc.id, messages: messages, participants: participants);
  }

  @override
  Future<RoomEntity> getRoomByChatUser(String uId, String chatUserId) async {
    final roomDoc = await rooms.get();
    for (var queryDocumentSnapshot in roomDoc.docs) {
      if ((queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
              .contains(uId) &&
          (queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
              .contains(chatUserId)) {
        final List<UserEntity> participants = [];
        for (String participantId
            in queryDocumentSnapshot.get(AppConstants.participantsKey)) {
          UserEntity user = await userRepository.getUserById(participantId);
          participants.add(user);
        }
        final messagesCollection = await rooms
            .doc(queryDocumentSnapshot.id)
            .collection(AppConstants.messagesKey)
            .get();
        final List<MessageEntity> messages = messagesCollection.docs.map((e) {
          return MessageEntity.fromJson(e.data()).copyWith(messageId: e.id);
        }).toList();
        return RoomEntity(
            roomId: queryDocumentSnapshot.id,
            messages: messages,
            participants: participants);
      }
    }
    return RoomEntity();
  }
}
