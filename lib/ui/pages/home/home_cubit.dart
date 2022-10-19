import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void onChangeSelectedIndex(int newIndex) {
    emit(state.copyWith(selectedIndex: newIndex));
  }
}
