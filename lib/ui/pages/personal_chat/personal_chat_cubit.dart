import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'personal_chat_state.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit(
      {required this.userRepository,
      required this.chatRepository,
      required this.authRepository})
      : super(const PersonalChatState());

  final ChatRepository chatRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<void> fetchRoomData() async {
    emit(state.copyWith(fetchRoomDataStatus: LoadStatus.loading));
    try {
      final String roomId = Get.parameters["roomId"] ?? "";
      final String userId = Get.parameters["userId"] ?? "";
      if (roomId.isNotEmpty && userId.isNotEmpty) {
        final room = await chatRepository.getRoomById(roomId);
        final chatUser = await userRepository.getUserById(userId);
        emit(
          state.copyWith(
              fetchRoomDataStatus: LoadStatus.success,
              room: room,
              chatUser: chatUser),
        );
      } else if (roomId.isEmpty && userId.isNotEmpty) {
        final room = await chatRepository.getRoomByChatUser(
            authRepository.getUid(), userId);
        final chatUser = await userRepository.getUserById(userId);
        emit(
          state.copyWith(
              fetchRoomDataStatus: LoadStatus.success,
              room: room,
              chatUser: chatUser),
        );
      } else {
        emit(state.copyWith(fetchRoomDataStatus: LoadStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(fetchRoomDataStatus: LoadStatus.failure));
    }
  }
}
