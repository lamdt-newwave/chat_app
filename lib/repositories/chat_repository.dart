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
}

class ChatRepositoryImpl extends ChatRepository {
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
    final CollectionReference rooms =
        FirebaseFirestore.instance.collection(AppConstants.roomsKey);
    final roomDoc = await rooms.orderBy("updatedTime", descending: true).get();
    List<RoomEntity> result = [];
    for (var queryDocumentSnapshot in roomDoc.docs) {
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
    return result;
  }
}
