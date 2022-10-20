import 'package:bloc/bloc.dart';
import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final AppCubit appCubit;

  SplashCubit({
    required this.appCubit,
    required this.userRepository,
    required this.authRepository,
  }) : super(const SplashState());

  void onGoSignUpWithPhonePage() {
    Get.toNamed(AppRoutes.signUpWithPhone);
  }

  Future<void> checkSignIn() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (authRepository.isSignedIn()) {
      final user = await userRepository.getUserById(authRepository.getUid());
      appCubit.updateUser(user);
      await userRepository.updateUser(user.copyWith(status: 1));
      Get.toNamed(AppRoutes.home);
    }
  }
}
