import 'package:bloc/bloc.dart';
import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/common/constants.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final AppCubit appCubit;

  ContactsCubit({
    required this.userRepository,
    required this.appCubit,
  }) : super(const ContactsState());

  final UserRepository userRepository;

  void onTextSearchChanged(String newValue) {
    emit(state.copyWith(searchText: newValue));
  }

  Future<void> fetchUsers() async {
    emit(state.copyWith(fetchUsersStatus: LoadStatus.loading));
    try {
      final result =
          await userRepository.fetchUsersWithoutUid(appCubit.state.user!.uId);
      emit(state.copyWith(fetchUsersStatus: LoadStatus.success, users: result));
    } catch (e) {
      emit(state.copyWith(fetchUsersStatus: LoadStatus.failure));
    }

    FirebaseFirestore.instance
        .collection(AppConstants.usersKey)
        .snapshots()
        .listen((querySnapshot) async {
      final result =
          await userRepository.fetchUsersWithoutUid(appCubit.state.user!.uId);
      emit(state.copyWith(fetchUsersStatus: LoadStatus.success, users: result));
    });
  }
}
