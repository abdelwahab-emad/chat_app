class BottomNavState {}

class BottomNavInitial extends BottomNavState {}

class BottomNavUpdated extends BottomNavState {
  final int index;

  BottomNavUpdated({required this.index});
}