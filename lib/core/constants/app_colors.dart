import 'package:flutter/material.dart';
import 'package:sama_task/data/models/task.dart';

class AppColors {
  static const Color primary = Color(0xFF080F29);
  static const Color secondary = Color(0xFF1082A6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFA21214);
  static const Color basse = Color(0xFF38A212);
  static const Color moyenne = Color(0xFFA24912);
  static const Color elevee = Color(0xFFA2127E);
  static const Color bgTaskItem = Color(0xFF5D6995);

  
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.elevee;
      case TaskPriority.medium:
        return AppColors.moyenne;
      case TaskPriority.low:
        return AppColors.basse;
      default:
        return AppColors.basse;
    }
  }
}
