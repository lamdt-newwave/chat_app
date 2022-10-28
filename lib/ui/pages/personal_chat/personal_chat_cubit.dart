import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'personal_chat_state.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit(
      {required this.userRepository,
      required this.chatRepository,
      required this.authRepository})
      : super(PersonalChatState());

  final ChatRepository chatRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<void> fetchInitData() async {
    emit(state.copyWith(fetchRoomDataStatus: LoadStatus.loading));
    try {
      final String roomId = Get.parameters["roomId"] ?? "";
      final String chatUserId = Get.parameters["chatUserId"] ?? "";
      if (roomId.isNotEmpty) {
        final room = await chatRepository.getRoomById(roomId);
        final UserEntity chatUser =
            await userRepository.getUserById(chatUserId);
        final List<ChatMessage> messages = room.messages
            .map((e) => ChatMessage(
                text: e.text,
                user: ChatUser(
                  id: e.authorId,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                    e.createdTime.millisecondsSinceEpoch)))
            .toList();

        emit(
          state.copyWith(
            fetchRoomDataStatus: LoadStatus.success,
            messages: List.from(messages.reversed),
            room: room,
            chatUser: chatUser,
          ),
        );
      } else if (roomId.isEmpty) {
        final UserEntity chatUser =
            await userRepository.getUserById(chatUserId);
        final room = await chatRepository.getRoomByChatUser(
            authRepository.getUid(), chatUserId);

        if (room.roomId.isNotEmpty) {
          final List<ChatMessage> messages = room.messages
              .map((e) => ChatMessage(
                  text: e.text,
                  user: ChatUser(
                    id: e.authorId,
                  ),
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                      e.createdTime.millisecondsSinceEpoch)))
              .toList();
          emit(
            state.copyWith(
              room: room,
              fetchRoomDataStatus: LoadStatus.success,
              messages: List.from(messages.reversed),
              chatUser: chatUser,
            ),
          );
        } else {
          RoomEntity room = await chatRepository.addNewRoom(chatUserId);
          emit(
            state.copyWith(
              chatUser: chatUser,
              room: room,
              fetchRoomDataStatus: LoadStatus.success,
            ),
          );
        }
      } else {
        final UserEntity chatUser =
            await userRepository.getUserById(chatUserId);
        emit(
          state.copyWith(
            chatUser: chatUser,
            fetchRoomDataStatus: LoadStatus.success,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
        fetchRoomDataStatus: LoadStatus.failure,
      ));
    }
  }

  Future<void> onSendMessage(ChatMessage newMessage) async {
    emit(state.copyWith(messageStatus: LoadStatus.loading));
    try {
      final result = await chatRepository.addNewMessage(MessageEntity(
          text: newMessage.text,
          authorId: authRepository.getUid(),
          createdTime: Timestamp.now(),
          roomId: state.room.roomId,
          updatedTime: Timestamp.now()));
      final List<ChatMessage> messages = [];
      messages.add(newMessage);
      messages.addAll(state.messages);
      emit(
        state.copyWith(
          messages: messages,
          messageStatus: LoadStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        messageStatus: LoadStatus.failure,
      ));
    }
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
