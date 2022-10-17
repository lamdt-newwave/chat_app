import 'package:bloc/bloc.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;

  SplashCubit({
    required this.authRepository,
  }) : super(const SplashState());

  void onGoSignUpWithPhonePage() {
    Get.toNamed(AppRoutes.signUpWithPhone);
  }

  Future<void> checkSignIn() async {
    await Future.delayed(const Duration(seconds: 2));
    if (authRepository.isSignedIn()) {
      Get.toNamed(AppRoutes.home);
    }
  }
}
