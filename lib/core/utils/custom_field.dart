import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? value;
  final int maxLines;
  final bool obscureText;
  final Color textColor;
  final FormFieldValidator<String>? validator;
  final bool filled;
  final Color fillColor;
  final InputBorder? enabledBorder;
  final InputBorder? border;

  const CustomField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.value,
    this.maxLines = 1,
    this.obscureText = false,
    this.textColor = AppColors.primary,
    this.validator,
    this.filled = true,
    this.fillColor = AppColors.secondary,
    this.enabledBorder,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(color: textColor),
        cursorColor: textColor.withOpacity(0.2),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: value == null || value!.isEmpty ? hintText : null,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          filled: filled,
          fillColor: fillColor.withOpacity(0.2),
          enabledBorder: enabledBorder ?? OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(8),
          ),
          border: border ?? OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}