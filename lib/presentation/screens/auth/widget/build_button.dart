import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String route;
  final BuildContext context;
  final Color? color; // Ajout d'une couleur personnalisable

  const CustomButton({
    Key? key,
    required this.text,
    required this.route,
    required this.context,
    this.color, // Paramètre optionnel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: AppColors.background),
        ),
      ),
    );
  }
}
