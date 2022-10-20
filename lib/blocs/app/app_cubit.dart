import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  AppCubit({required this.userRepository, required this.authRepository})
      : super(const AppState());

  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }

  void signOut() {
    authRepository.signOut();
    userRepository.updateUser(
      state.user!,
      status: 0,
      lastTime: Timestamp.fromDate(
        DateTime.now(),
      ),
    );

    emit(
      state.copyWith(
        user: null,
      ),
    );
  }
}
