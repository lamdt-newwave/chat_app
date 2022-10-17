part of 'profile_account_cubit.dart';

class ProfileAccountState extends Equatable {
  const ProfileAccountState({
    this.firstName = "",
    this.lastName = "",
    this.avatarPath = "",
  });

  final String firstName;
  final String lastName;
  final String avatarPath;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        avatarPath,
      ];

  ProfileAccountState copyWith(
      {String? firstName, String? lastName, String? avatarPath}) {
    return ProfileAccountState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
