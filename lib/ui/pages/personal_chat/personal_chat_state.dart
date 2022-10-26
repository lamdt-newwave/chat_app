part of 'personal_chat_cubit.dart';

class PersonalChatState extends Equatable {
  const PersonalChatState(
      {this.room,
      this.user,
      this.chatUser,
      this.fetchRoomDataStatus = LoadStatus.initial});

  final RoomEntity? room;
  final UserEntity? chatUser;
  final LoadStatus fetchRoomDataStatus;
  final UserEntity? user;

  @override
  List<Object?> get props => [room, chatUser, fetchRoomDataStatus, user];

  PersonalChatState copyWith({
    RoomEntity? room,
    UserEntity? chatUser,
    UserEntity? user,
    LoadStatus? fetchRoomDataStatus,
  }) {
    return PersonalChatState(
      chatUser: chatUser ?? this.chatUser,
      room: room ?? this.room,
      user: user ?? this.user,
      fetchRoomDataStatus: fetchRoomDataStatus ?? this.fetchRoomDataStatus,
    );
  }
}
