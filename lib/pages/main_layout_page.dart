import 'package:chat_app/pages/people_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/cubits/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:chat_app/cubits/bottom_nav_cubit/bottom_nav_states.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/profile_page.dart';

class MainLayoutPage extends StatelessWidget {
  static const String id = 'main_layout_page';

  final List<Widget> _pages = const [
    HomePage(),
    PeoplePage(),
    ProfilePage(),
  ];

  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<BottomNavCubit>(context);

        return Scaffold(
          body: _pages[cubit.currentIndex],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeIndex(index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF0865FE),
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble, size: 28),
                  ),
                  label: 'chats',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.people, size: 28),
                  ),
                  label: 'People',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.menu, size: 28),
                  ),
                  label: 'Menu',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}