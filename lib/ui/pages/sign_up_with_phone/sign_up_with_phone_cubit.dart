import 'package:bloc/bloc.dart';
import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:chat_app/ui/widgets/commons/app_snackbars.dart';
import 'package:country_pickers/country.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

part 'sign_up_with_phone_state.dart';

class SignUpWithPhoneCubit extends Cubit<SignUpWithPhoneState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final AppCubit appCubit;

  SignUpWithPhoneCubit({
    required this.appCubit,
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
    if (state.isCorrectPhoneNumber) {
      AppDialogs.showLoadingDialog();
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+${state.selectedCountry.phoneCode} ${state.phoneNumber}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == "invalid-phone-number") {
            AppSnackbars.showErrorSnackbar(
                title: "Invalid Phone Number",
                message: "Please check your phone number and try again.");
          }
          Get.back();
        },
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
        final user = await userRepository.getUserById(authRepository.getUid());
        appCubit.updateUser(user);
        await userRepository.updateUser(user.copyWith(status: 1));
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
      if (e.code == "invalid-verification-code") {
        AppSnackbars.showErrorSnackbar(
            title: "Invalid Verification Code",
            message: "The OTP you've entered is incorrect. Please try again.");
      }
    }
  }
}
