import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomEntity {
  final String roomId;
  final List<UserEntity> participants;
  final Timestamp createdTime;
  final Timestamp updatedTime;
  final List<MessageEntity> messages;

  RoomEntity({
    this.messages = const [],
    this.roomId = "",
    this.participants = const [],
    Timestamp? createdTime,
    Timestamp? updatedTime,
  })  : createdTime = createdTime ?? Timestamp.now(),
        updatedTime = updatedTime ?? Timestamp.now();

  RoomEntity copyWith(
      {String? roomId,
      List<UserEntity>? participants,
      Timestamp? createdTime,
      Timestamp? updatedTime,
      List<MessageEntity>? messages}) {
    return RoomEntity(
      messages: messages ?? this.messages,
      roomId: roomId ?? this.roomId,
      participants: participants ?? this.participants,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  String getLastMessage() {
    if (messages.isEmpty) return "Nothing";

    MessageEntity lastMessage = messages.last;
    if (lastMessage.text.isNotEmpty) {
      return lastMessage.text;
    } else {
      if (lastMessage.type.contains("image/")) {
        return "Image";
      } else {
        return "Something. Don't know!!! ";
      }
    }
  }

  int getUnreadMessages() {
    if (messages.isEmpty) return 0;

    MessageEntity lastMessage = messages.last;
    final AuthRepository authRepository = AuthRepositoryImpl();
    if (lastMessage.authorId == authRepository.getUid()) {
      return 0;
    }
    int unreadMessages = 0;

    for (MessageEntity message in messages.reversed) {
      if (message.authorId == authRepository.getUid()) {
        break;
      }
      unreadMessages++;
    }
    return unreadMessages;
  }
}
