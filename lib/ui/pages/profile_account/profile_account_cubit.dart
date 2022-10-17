import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_account_state.dart';

class ProfileAccountCubit extends Cubit<ProfileAccountState> {
  final UserRepository userRepository;

  ProfileAccountCubit({required this.userRepository})
      : super(const ProfileAccountState());

  void onFirstNameChanged(String newValue) {
    emit(state.copyWith(firstName: newValue));
  }

  void onLastNameChanged(String newValue) {
    emit(state.copyWith(lastName: newValue));
  }

  Future<void> onSave() async {
    if (state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.avatarPath.isNotEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      File avatar = File(state.avatarPath);
      final imageRef = storageRef.child("images/${avatar.path.split("").last}");
      try {
        await imageRef.putFile(avatar);
        final avatarUrl = await imageRef.getDownloadURL();
        final para = Get.parameters;
        final String uId = para["uId"] ?? "";
        final String phoneCode = para["phoneCode"] ?? "";
        final String phoneNumber = para["phoneNumber"] ?? "";
        UserEntity userEntity = UserEntity(
          phoneCode: phoneCode,
          uId: uId,
          lastName: state.firstName,
          firstName: state.lastName,
          avatarUrl: avatarUrl,
          phoneNumber: phoneNumber,
          createdTime: Timestamp.fromDate(DateTime.now()),
          lastTime: Timestamp.fromDate(DateTime.now()),
        );
        userRepository.addUser(userEntity: userEntity);
        print("Done");
      } on FirebaseException catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> onPickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(state.copyWith(avatarPath: image.path));
    }
  }
}
