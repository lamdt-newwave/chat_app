part of 'chats_cubit.dart';

class ChatsState extends Equatable {
  const ChatsState(
      {this.rooms = const [],
      this.stories = const [],
      this.fetchRoomsStatus = LoadStatus.initial,
      this.fetchStoriesStatus = LoadStatus.initial});

  final LoadStatus fetchRoomsStatus;
  final LoadStatus fetchStoriesStatus;
  final List<RoomEntity> rooms;
  final List<StoryEntity> stories;

  @override
  List<Object> get props =>
      [fetchRoomsStatus, fetchStoriesStatus, rooms, stories];

  ChatsState copyWith(
      {List<RoomEntity>? rooms,
      List<StoryEntity>? stories,
      LoadStatus? fetchRoomsStatus,
      LoadStatus? fetchStoriesStatus}) {
    return ChatsState(
        rooms: rooms ?? this.rooms,
        stories: stories ?? this.stories,
        fetchRoomsStatus: fetchRoomsStatus ?? this.fetchRoomsStatus,
        fetchStoriesStatus: fetchStoriesStatus ?? this.fetchStoriesStatus);
  }
}
