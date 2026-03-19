import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.controller,
    this.hasError = false,
    this.readOnly = false,
    this.prefixIcon,
    this.textColor = Colors.white,
    this.validator,
    this.suffixIcon,
    this.obscureText = false,
    this.onSuffixPressed,
    this.borderRadius = 15.0,
    this.prefixIconSize = 22.0,
    this.keyboardType,
  });

  final String? hintText;
  final String? labelText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool hasError;
  final bool readOnly;
  final IconData? prefixIcon;
  final Color textColor;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final bool obscureText;
  final void Function()? onSuffixPressed;
  final double borderRadius;
  final double prefixIconSize;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType ?? TextInputType.text,
        readOnly: readOnly,
        cursorColor: textColor,
        style: TextStyle(color: readOnly ? Colors.grey.shade700 : textColor),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
          labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
          floatingLabelBehavior: readOnly ? FloatingLabelBehavior.never : FloatingLabelBehavior.auto,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: hasError ? Colors.red : textColor, size: prefixIconSize)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: onSuffixPressed,
                  icon: Icon(suffixIcon, color: textColor, size: 22),
                  splashColor: Colors.transparent,
                )
              : null,
          filled: readOnly,
          fillColor: Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : textColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : textColor,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}