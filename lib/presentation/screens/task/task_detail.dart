import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';

class TaskDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final Color color;

  const TaskDetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Task Detail",
          style: TextStyle(color: AppColors.background),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.background,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 8 / 2, horizontal: 16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10), // Coins arrondis
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20), // Ajout de l'espace après le contenu
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30), // Ajout d'espace après la date
            Column(
              children: [
                CustomButton(
                  text: "Update",
                  route: "/updateTask",
                  context: context,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Delete",
                  route: "/deleteTask",
                  context: context,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
