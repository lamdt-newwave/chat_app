part of 'contacts_cubit.dart';

class ContactsState extends Equatable {
  const ContactsState({
    this.users = const [],
    this.fetchUsersStatus = LoadStatus.initial,
    this.searchText = "",
  });

  final String searchText;
  final LoadStatus fetchUsersStatus;
  final List<UserEntity> users;

  @override
  List<Object> get props => [searchText, fetchUsersStatus, users];

  ContactsState copyWith(
      {String? searchText,
      LoadStatus? fetchUsersStatus,
      List<UserEntity>? users}) {
    return ContactsState(
        users: users ?? this.users,
        searchText: searchText ?? this.searchText,
        fetchUsersStatus: fetchUsersStatus ?? this.fetchUsersStatus);
  }
}
