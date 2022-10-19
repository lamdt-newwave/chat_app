import 'package:bloc/bloc.dart';
import 'package:chat_app/common/constants.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({required this.userRepository}) : super(const ContactsState());

  final UserRepository userRepository;

  void onTextSearchChanged(String newValue) {
    emit(state.copyWith(searchText: newValue));
  }

  Future<void> fetchUsers() async {
    emit(state.copyWith(fetchUsersStatus: LoadStatus.loading));
    try {
      final result = await userRepository.fetchUsers();
      emit(state.copyWith(fetchUsersStatus: LoadStatus.success, users: result));
    } catch (e) {
      emit(state.copyWith(fetchUsersStatus: LoadStatus.failure));
    }

    FirebaseFirestore.instance
        .collection(AppConstants.usersKey)
        .snapshots()
        .listen((querySnapshot) {
      final users = querySnapshot.docs.map((e) {
        UserEntity userEntity = UserEntity.fromJsonWithoutUid(e.data());
        return userEntity.copyWith(uId: e.id);
      }).toList();
      emit(state.copyWith(users: users));
    });
  }
}
