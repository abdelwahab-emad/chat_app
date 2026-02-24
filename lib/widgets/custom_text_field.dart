import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.hasError = false,
    this.readOnly = false,
    this.prefixIcon,
    this.textColor = Colors.white,
  });
  // to control the text inside the text field

  final String hintText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool hasError;
  final bool readOnly;
  final IconData? prefixIcon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(color: readOnly ? Colors.grey.shade700 : textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: hasError ? Colors.red : textColor)
              : null,
          filled: readOnly,
          fillColor: Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : textColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: hasError ? Colors.red : textColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          suffixIcon: readOnly
              ? null
              : IconButton(
                  onPressed: () {
                    controller?.clear();
                  },
                  icon: Icon(Icons.clear, color: textColor),
                ),
        ),
      ),
    );
  }
}
