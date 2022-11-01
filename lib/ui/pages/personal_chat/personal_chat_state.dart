part of 'personal_chat_cubit.dart';

class PersonalChatState extends Equatable {
  final LoadStatus fetchRoomDataStatus;
  final List<MessageEntity> messages;
  final UserEntity? chatUser;
  final RoomEntity room;
  final LoadStatus messageStatus;
  final String replyingMessageId;

  PersonalChatState({
    this.replyingMessageId = "",
    this.messages = const [],
    this.chatUser,
    RoomEntity? room,
    this.fetchRoomDataStatus = LoadStatus.initial,
    this.messageStatus = LoadStatus.initial,
  }) : room = room ??
            RoomEntity(
              roomId: "",
            );

  PersonalChatState copyWith({
    LoadStatus? fetchRoomDataStatus,
    List<MessageEntity>? messages,
    RoomEntity? room,
    UserEntity? chatUser,
    LoadStatus? messageStatus,
    String? replyingMessageId,
  }) {
    return PersonalChatState(
      replyingMessageId: replyingMessageId ?? this.replyingMessageId,
      room: room ?? this.room,
      chatUser: chatUser ?? this.chatUser,
      messages: messages ?? this.messages,
      fetchRoomDataStatus: fetchRoomDataStatus ?? this.fetchRoomDataStatus,
      messageStatus: messageStatus ?? this.messageStatus,
    );
  }

  @override
  List<Object?> get props =>
      [
        fetchRoomDataStatus,
        messages,
        chatUser,
        room,
        messageStatus,
        replyingMessageId,
      ];
}
