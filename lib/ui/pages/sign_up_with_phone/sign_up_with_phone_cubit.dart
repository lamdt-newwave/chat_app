import 'package:bloc/bloc.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:country_pickers/country.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

part 'sign_up_with_phone_state.dart';

class SignUpWithPhoneCubit extends Cubit<SignUpWithPhoneState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignUpWithPhoneCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(SignUpWithPhoneState());

  void onSelectedCountryChanged(Country newCountry) {
    emit(state.copyWith(selectedCountry: newCountry));
  }

  void onPhoneNumberChanged(String newValue) {
    emit(state.copyWith(phoneNumber: newValue));
  }

  Future<void> onMoveToVerification() async {
    AppDialogs.showLoadingDialog();
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+${state.selectedCountry.phoneCode} ${state.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Get.back();
        emit(
          state.copyWith(
            isVerifying: true,
            verificationId: verificationId,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void onResendCode() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+${state.selectedCountry.phoneCode} ${state.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        emit(state.copyWith(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> onSignIn(String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId, smsCode: code);
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (await userRepository.isExistedUser(uId: result.user?.uid ?? "")) {
        authRepository.saveUid(result.user?.uid ?? "");
        Get.toNamed(AppRoutes.home);
      } else {
        Get.toNamed(
          AppRoutes.profileAccount,
          parameters: {
            "uId": result.user!.uid,
            "phoneNumber": state.phoneNumber,
            "phoneCode": state.selectedCountry.phoneCode,
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
