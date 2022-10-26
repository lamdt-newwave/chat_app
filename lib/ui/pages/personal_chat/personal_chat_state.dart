part of 'personal_chat_cubit.dart';

class PersonalChatState extends Equatable {
  const PersonalChatState(
      {this.room,
      this.chatUser,
      this.fetchRoomDataStatus = LoadStatus.initial});

  final RoomEntity? room;
  final UserEntity? chatUser;
  final LoadStatus fetchRoomDataStatus;

  @override
  List<Object?> get props => [room, chatUser];

  PersonalChatState copyWith({
    RoomEntity? room,
    UserEntity? chatUser,
    LoadStatus? fetchRoomDataStatus,
  }) {
    return PersonalChatState(
      chatUser: chatUser ?? this.chatUser,
      room: room ?? this.room,
      fetchRoomDataStatus: fetchRoomDataStatus ?? this.fetchRoomDataStatus,
    );
  }
}
