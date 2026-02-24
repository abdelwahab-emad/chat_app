import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
      super.key,
      required this.title,
      required this.icon,
      required this.onTap, 
      this.isDestructive = false,  
      this.badgeCount = 0,
  });

  final String title;
  final IconData icon;                                                                                                                                                                                                                                                                        
  final VoidCallback onTap;
  final bool isDestructive;
  final int badgeCount;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDestructive ? Colors.red.shade50 : Colors.grey.shade100,),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(skprimaryColor),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize : 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),

      trailing: badgeCount > 0
      ? Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$badgeCount',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) : const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      )
    );
  }
}