part of 'profile_account_cubit.dart';

class ProfileAccountState extends Equatable {
  const ProfileAccountState({
    this.firstName = "",
    this.lastName = "",
    this.avatarUrl = "",
  });

  final String firstName;
  final String lastName;
  final String avatarUrl;

  bool get isEnableSave =>
      firstName.isNotEmpty && lastName.isNotEmpty && avatarUrl.isNotEmpty;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        avatarUrl,
      ];

  ProfileAccountState copyWith(
      {String? firstName, String? lastName, String? avatarUrl}) {
    return ProfileAccountState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
