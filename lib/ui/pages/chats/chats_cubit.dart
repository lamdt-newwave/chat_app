import 'package:bloc/bloc.dart';
import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/common/constants.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/story_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatRepository chatRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final AppCubit appCubit;

  ChatsCubit(
      {required this.userRepository,
      required this.authRepository,
      required this.appCubit,
      required this.chatRepository})
      : super(const ChatsState());

  Future<void> fetchStories() async {
    emit(state.copyWith(fetchStoriesStatus: LoadStatus.loading));
    try {
      final result = await chatRepository.fetchStories();
      emit(state.copyWith(
          fetchStoriesStatus: LoadStatus.success, stories: result));
    } catch (e) {
      emit(state.copyWith(fetchStoriesStatus: LoadStatus.failure));
    }
  }

  Future<void> fetchRooms() async {
    emit(state.copyWith(fetchRoomsStatus: LoadStatus.loading));
    try {
      final result = await chatRepository.fetchRooms(authRepository.getUid());
      emit(state.copyWith(fetchRoomsStatus: LoadStatus.success, rooms: result));
    } catch (e) {
      emit(state.copyWith(fetchRoomsStatus: LoadStatus.failure));
    }

    FirebaseFirestore.instance
        .collection(AppConstants.roomsKey)
        .snapshots()
        .listen((querySnapshot) async {
      final result = await chatRepository.fetchRooms(authRepository.getUid());
      emit(state.copyWith(fetchRoomsStatus: LoadStatus.success, rooms: result));
    });

    FirebaseFirestore.instance
        .collection(AppConstants.usersKey)
        .snapshots()
        .listen((querySnapshot) async {
      final result = await chatRepository.fetchRooms(authRepository.getUid());
      emit(state.copyWith(fetchRoomsStatus: LoadStatus.success, rooms: result));
    });
  }
}
