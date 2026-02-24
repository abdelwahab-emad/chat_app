import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/menu_page.dart';
import 'package:chat_app/pages/people_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  BottomNavBar({super.key, required this.currentIndex});

  final Color color = Colors.grey.shade700;
  Color getColor(int index) {
    if (index == currentIndex) {
      return Color(skprimaryColor);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacementNamed(context, HomePage.id);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat, color: getColor(0)),
                Text('chats', style: TextStyle(color: getColor(0))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex != 1) {
                Navigator.pushReplacementNamed(context, PeoplePage.id);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, color: getColor(1)),
                Text('People', style: TextStyle(color: getColor(1))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex != 2) {
                Navigator.pushReplacementNamed(context, MenuPage.id);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu, color: getColor(2)),
                Text('Menu', style: TextStyle(color: getColor(2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
