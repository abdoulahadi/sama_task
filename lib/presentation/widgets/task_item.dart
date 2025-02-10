import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/screens/task/task_detail.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final Color color;

  const TaskItem({
    super.key,
    required this.title,
    required this.date,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Naviguer vers la page de détails
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              title: title,
              content: content,
              date: date,
              color: color,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgTaskItem,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: ListTile(
                  textColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(content),
                  trailing: Text(
                    date,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}