import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.boxColor, required this.textColor, this.onTap});
  
  final String text;
  final Color boxColor;
  final Color textColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector( // to make the button clickable
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Color(0xFF0865FE)),
          ),
          width: double.infinity,
          height: 45,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
