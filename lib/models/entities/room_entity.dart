import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/auth_repository.dart';

class RoomEntity {
  final String roomId;
  final List<UserEntity> participants;

  final List<MessageEntity> messages;

  RoomEntity(
      {required this.roomId,
      this.participants = const [],
      this.messages = const []});

  RoomEntity copyWith({
    String? roomId,
    List<UserEntity>? participants,
    List<MessageEntity>? messages,
  }) {
    return RoomEntity(
      roomId: roomId ?? this.roomId,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
    );
  }

  String getLastMessage() {
    MessageEntity lastMessage = messages.last;
    if (lastMessage.text.isNotEmpty) {
      return lastMessage.text;
    } else {
      if (lastMessage.typeMedia.contains("image/")) {
        return "Image";
      } else {
        return "Something. Don't know!!! ";
      }
    }
  }

  int getUnreadMessages() {
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
