import 'package:bloc/bloc.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:country_pickers/country.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

part 'sign_up_with_phone_state.dart';

class SignUpWithPhoneCubit extends Cubit<SignUpWithPhoneState> {
  SignUpWithPhoneCubit() : super(SignUpWithPhoneState());

  void onSelectedCountryChanged(Country newCountry) {
    emit(state.copyWith(selectedCountry: newCountry));
  }

  void onPhoneNumberChanged(String newValue) {
    emit(state.copyWith(phoneNumber: newValue));
  }

  Future<void> onMoveToVerification() async {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+${state.selectedCountry.phoneCode} ${state.phoneNumber}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          emit(state.copyWith(
              isVerifying: true, verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }

  void onResendCode() {}

  Future<void> onSignIn(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId, smsCode: code);
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.toNamed(AppRoutes.home);
  }
}
