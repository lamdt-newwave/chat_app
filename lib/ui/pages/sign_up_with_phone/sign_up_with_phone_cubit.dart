import 'package:bloc/bloc.dart';
import 'package:country_pickers/country.dart';
import 'package:equatable/equatable.dart';
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

  void onMoveToVerification() {
    emit(state.copyWith(isVerifying: true));
  }

  void onResendCode(){

  }


}
