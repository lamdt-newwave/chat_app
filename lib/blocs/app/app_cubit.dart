import 'package:bloc/bloc.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }

  void logout() {
    emit(
      state.copyWith(
        user: state.user?.copyWith(
          status: 0,
          lastTime: Timestamp.fromDate(DateTime.now()) ,
        ),
      ),
    );
  }
}
