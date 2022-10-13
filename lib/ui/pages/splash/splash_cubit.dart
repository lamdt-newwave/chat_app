import 'package:bloc/bloc.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  void onGoSignUpWithPhonePage(){
    Get.toNamed(AppRoutes.signUpWithPhone);
  }















}
