import 'package:chat_app/cubits/bottom_nav_cubit/bottom_nav_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavInitial());

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(BottomNavUpdated(index: index));
  }
}