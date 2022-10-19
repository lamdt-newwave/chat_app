import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_account_state.dart';

class ProfileAccountCubit extends Cubit<ProfileAccountState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  ProfileAccountCubit({
    required this.userRepository,
    required this.authRepository,
  }) : super(const ProfileAccountState());

  void onFirstNameChanged(String newValue) {
    emit(state.copyWith(firstName: newValue));
  }

  void onLastNameChanged(String newValue) {
    emit(state.copyWith(lastName: newValue));
  }

  Future<void> onSave() async {
    if (state.isEnableSave) {
      AppDialogs.showLoadingDialog();
      try {
        final para = Get.parameters;
        final String uId = para["uId"] ?? "";
        final String phoneCode = para["phoneCode"] ?? "";
        final String phoneNumber = para["phoneNumber"] ?? "";
        UserEntity userEntity = UserEntity(
          status: 1,
          phoneCode: phoneCode,
          uId: uId,
          lastName: state.firstName,
          firstName: state.lastName,
          avatarUrl: state.avatarUrl,
          phoneNumber: phoneNumber,
          createdTime: Timestamp.fromDate(DateTime.now()),
          lastTime: Timestamp.fromDate(DateTime.now()),
        );
        await userRepository.addUser(userEntity: userEntity);
        authRepository.saveUid(uId);
        Get.back();
        Get.toNamed(AppRoutes.home);
      } on FirebaseException {
        Get.back();
      }
    }
  }

  Future<void> onPickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final storageRef = FirebaseStorage.instance.ref();
      File avatar = File(image.path);
      final imageRef = storageRef.child("images/${image.name}");
      await imageRef.putFile(avatar).then((taskSnapShot) async {
        final avatarUrl = await imageRef.getDownloadURL();
        emit(state.copyWith(avatarUrl: avatarUrl));
      });
    }
  }
}
