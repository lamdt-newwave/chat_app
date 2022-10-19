part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});

  @override
  List<Object> get props => [selectedIndex];

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
