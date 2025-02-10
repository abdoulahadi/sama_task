import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';

class CustomField extends StatelessWidget {
  final String? value;
  final String hint;
  final bool obscureText;
  final Color textColor;

  const CustomField({
    Key? key,
    this.value,
    required this.hint,
    this.obscureText = false,
    this.textColor = AppColors.background, // Valeur par défaut
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      cursorColor: textColor.withOpacity(0.2),
      style: TextStyle(color: textColor), // Applique la couleur du texte
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.secondary.withOpacity(0.2),
        hintText: value == null || value!.isEmpty ? hint : null,
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)), // Couleur du hint en plus clair
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
