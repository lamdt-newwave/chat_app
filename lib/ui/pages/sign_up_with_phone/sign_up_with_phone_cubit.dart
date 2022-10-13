import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_with_phone_state.dart';

class SignUpWithPhoneCubit extends Cubit<SignUpWithPhoneState> {
  SignUpWithPhoneCubit() : super(const SignUpWithPhoneState());
}
