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

  Future<List<MessageEntity>> getMessagesByRoomId(String roomId);

  Future<MessageEntity> addNewMessage(MessageEntity messageEntity);

  Future<RoomEntity> addNewRoom(String chatUserId);

  Future<List<UserEntity>> getParticipantsByRoomId(String roomId);
}

class ChatRepositoryImpl extends ChatRepository {
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection(AppConstants.roomsKey);
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(AppConstants.messagesKey);
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
    final roomColl = await rooms.orderBy("updatedTime", descending: true).get();
    List<RoomEntity> result = [];
    for (var queryDocumentSnapshot in roomColl.docs) {
      if ((queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
          .contains(uId)) {
        final List<UserEntity> participants =
            await getParticipantsByRoomId(queryDocumentSnapshot.id);
        List<MessageEntity> messagesList =
            await getMessagesByRoomId(queryDocumentSnapshot.id);
        result.add(RoomEntity(
            roomId: queryDocumentSnapshot.id,
            messages: messagesList,
            participants: participants));
      }
    }
    return result;
  }

  @override
  Future<RoomEntity> getRoomById(String roomId) async {
    final roomDoc = await rooms.doc(roomId).get();
    final List<UserEntity> participants = await getParticipantsByRoomId(roomId);
    List<MessageEntity> messagesList = await getMessagesByRoomId(roomId);
    return RoomEntity(
        roomId: roomDoc.id, messages: messagesList, participants: participants);
  }

  @override
  Future<RoomEntity> getRoomByChatUser(String uId, String chatUserId) async {
    final roomDoc = await rooms.get();
    for (var queryDocumentSnapshot in roomDoc.docs) {
      if ((queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
              .contains(uId) &&
          (queryDocumentSnapshot.get(AppConstants.participantsKey) as List)
              .contains(chatUserId)) {
        final List<UserEntity> participants =
            await getParticipantsByRoomId(queryDocumentSnapshot.id);
        List<MessageEntity> messagesList =
            await getMessagesByRoomId(queryDocumentSnapshot.id);
        return RoomEntity(
            roomId: queryDocumentSnapshot.id,
            messages: messagesList,
            participants: participants);
      }
    }
    return RoomEntity();
  }

  @override
  Future<MessageEntity> addNewMessage(MessageEntity messageEntity) async {
    final messageId =
        (await messages.add(messageEntity.toJsonWithoutMessageId())).id;
    return messageEntity.copyWith(messageId: messageId);
  }

  @override
  Future<RoomEntity> addNewRoom(String chatUserId) async {
    final roomId = (await rooms.add({
      "createdTime": Timestamp.now(),
      "updatedTime": Timestamp.now(),
      "participants": [authRepository.getUid(), chatUserId]
    }))
        .id;

    return RoomEntity(roomId: roomId);
  }

  @override
  Future<List<MessageEntity>> getMessagesByRoomId(String roomId) async {
    final messagesColl = await messages
        .orderBy("createdTime")
        .where("roomId", isEqualTo: roomId)
        .get();
    List<MessageEntity> messagesList = [];
    for (var messageSnapshot in messagesColl.docs) {
      final MessageEntity messageEntity =
          MessageEntity.fromJson(messageSnapshot.data() as Map<String, dynamic>)
              .copyWith(messageId: messageSnapshot.id);
      messagesList.add(messageEntity);
    }
    ;
    return messagesList;
  }

  @override
  Future<List<UserEntity>> getParticipantsByRoomId(String roomId) async {
    final List<UserEntity> participants = [];
    final room = await rooms.doc(roomId).get();
    for (String participantId in room.get(AppConstants.participantsKey)) {
      UserEntity user = await userRepository.getUserById(participantId);
      participants.add(user);
    }
    return participants;
  }
}
