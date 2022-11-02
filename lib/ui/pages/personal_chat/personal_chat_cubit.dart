import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/models/enums/message_type.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:chat_app/utils/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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

  Future<void> fetchInitData(AppStream appStream) async {
    emit(state.copyWith(fetchRoomDataStatus: LoadStatus.loading));
    try {
      final String roomId = Get.parameters["roomId"] ?? "";
      final String chatUserId = Get.parameters["chatUserId"] ?? "";
      // Navigate from chats page

      if (roomId.isNotEmpty) {
        final room = await chatRepository.getRoomById(roomId);
        final UserEntity chatUser =
            await userRepository.getUserById(chatUserId);
        emit(
          state.copyWith(
            fetchRoomDataStatus: LoadStatus.success,
            room: room,
            messages: room.messages,
            chatUser: chatUser,
          ),
        );
      }

      // Navigate from contacts page
      else if (roomId.isEmpty) {
        final UserEntity chatUser =
            await userRepository.getUserById(chatUserId);
        final room = await chatRepository.getRoomByChatUser(
            authRepository.getUid(), chatUserId);
        if (room.roomId.isNotEmpty) {
          emit(
            state.copyWith(
              room: room,
              messages: room.messages,
              fetchRoomDataStatus: LoadStatus.success,
              chatUser: chatUser,
            ),
          );
        } else {
          RoomEntity room = await chatRepository.addNewRoom(chatUserId);
          emit(
            state.copyWith(
              chatUser: chatUser,
              messages: room.messages,
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
            messages: [],
            room: RoomEntity(),
            chatUser: chatUser,
            fetchRoomDataStatus: LoadStatus.success,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          messages: [],
          chatUser: null,
          room: RoomEntity(),
          fetchRoomDataStatus: LoadStatus.failure,
        ),
      );
    }

    appStream.messagesController.stream.listen((event) {
      loadMessages();
    });
  }

  Future<void> loadMessages() async {
    final result = await chatRepository.getMessagesByRoomId(state.room.roomId);
    emit(
      state.copyWith(messages: result),
    );
  }

  Future<void> onSendTextMessage(String newMessage) async {
    emit(state.copyWith(messageStatus: LoadStatus.loading));
    try {
      final result = await chatRepository.addNewMessage(
        MessageEntity(
          repliedMessageId: state.replyingMessageId,
          type: MessageType.text.toString(),
          text: newMessage,
          authorId: authRepository.getUid(),
          createdTime: Timestamp.now(),
          roomId: state.room.roomId,
          updatedTime: Timestamp.now(),
        ),
      );
      final List<MessageEntity> messages = [];
      messages.addAll(state.room.messages);
      messages.add(result);
      emit(
        state.copyWith(
            room: state.room.copyWith(messages: messages),
            messageStatus: LoadStatus.success,
            replyingMessageId: ""),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messageStatus: LoadStatus.failure,
          replyingMessageId: "",
        ),
      );
    }
  }

  Future<List<MessageEntity>> sendMessage(
      {String text = "",
      String url = "",
      required MessageType type,
      String thumbnailUrl = ""}) async {
    final result = await chatRepository.addNewMessage(
      MessageEntity(
          repliedMessageId: state.replyingMessageId,
          text: text,
          thumbnailUrl: thumbnailUrl,
          type: type.toString(),
          authorId: authRepository.getUid(),
          createdTime: Timestamp.now(),
          roomId: state.room.roomId,
          updatedTime: Timestamp.now(),
          mediaUrl: url),
    );
    final List<MessageEntity> messages = [];
    messages.addAll(state.room.messages);
    messages.add(result);
    return messages;
  }

  Future<void> onUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Please select file to upload!!",
    );

    try {
      AppDialogs.showLoadingDialog();
      if (result != null) {
        File file = File(result.files.single.path!);
        String? mimeStr = lookupMimeType(file.path);
        var fileType = mimeStr?.split('/').first;
        final storageRef = FirebaseStorage.instance.ref();
        if (fileType == "image") {
          final imageRef =
              storageRef.child("images/${result.files.single.name}");
          await imageRef.putFile(file).then((taskSnapShot) async {
            final url = await imageRef.getDownloadURL();
            final List<MessageEntity> messages =
                await sendMessage(type: MessageType.image, url: url);
            emit(
              state.copyWith(
                room: state.room.copyWith(messages: messages),
                messageStatus: LoadStatus.success,
                replyingMessageId: "",
              ),
            );
          });
        } else if (fileType == "audio") {
          final audioRef =
              storageRef.child("audio/${result.files.single.name}");
          await audioRef.putFile(file).then((taskSnapShot) async {
            final url = await audioRef.getDownloadURL();
            final List<MessageEntity> messages =
                await sendMessage(type: MessageType.audio, url: url);
            emit(
              state.copyWith(
                room: state.room.copyWith(messages: messages),
                messageStatus: LoadStatus.success,
                replyingMessageId: "",
              ),
            );
          });
        } else if (fileType == "video") {
          final audioRef =
              storageRef.child("videos/${result.files.single.name}");

          final thumbnailFilePath = await VideoThumbnail.thumbnailFile(
            video: result.files.single.path!,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 240,
            quality: 75,
          );
          File thumbnailFile = File(thumbnailFilePath!);
          final imageRef =
              storageRef.child("images/${thumbnailFile.path.split("/").last}");
          await imageRef.putFile(thumbnailFile);
          await audioRef.putFile(file).then((taskSnapShot) async {
            final url = await audioRef.getDownloadURL();
            final List<MessageEntity> messages = await sendMessage(
                type: MessageType.video,
                url: url,
                thumbnailUrl: await imageRef.getDownloadURL());
            emit(
              state.copyWith(
                room: state.room.copyWith(messages: messages),
                messageStatus: LoadStatus.success,
                replyingMessageId: "",
              ),
            );
          });
        } else {
          final fileRef = storageRef.child("files/${result.files.single.name}");
          await fileRef.putFile(file).then((taskSnapShot) async {
            final url = await fileRef.getDownloadURL();
            final List<MessageEntity> messages =
                await sendMessage(type: MessageType.file, url: url);
            emit(
              state.copyWith(
                room: state.room.copyWith(messages: messages),
                messageStatus: LoadStatus.success,
                replyingMessageId: "",
              ),
            );
          });
        }
      } else {}
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  void onReplyMessage(String repliedMessageId) {
    emit(state.copyWith(replyingMessageId: repliedMessageId));
  }
}
