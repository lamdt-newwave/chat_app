import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'personal_chat_state.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(PersonalChatInitial());
}
