part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({this.user});

  final UserEntity? user;

  @override
  List<Object?> get props => [user];

  AppState copyWith({
    UserEntity? user,
  }) {
    return AppState(
      user: user ?? this.user,
    );
  }
}
