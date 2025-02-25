import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/utils/format_date.dart';
import 'package:sama_task/data/models/task.dart';
import 'package:sama_task/data/repositories/shared_preferences.dart';
import 'package:sama_task/presentation/screens/task/task_detail.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String date;
  final TaskPriority priority;
  final DateTime dueDate;
  final Color color;

  const TaskItem({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.priority,
    required this.dueDate,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? token = await UserPreferences.getToken();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              task: Task(
                  id: id,
                  title: title,
                  content: content,
                  priority: priority,
                  color: color.toString(),
                  dueDate: dueDate),
              jwt: token!,
            ),
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(content, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text(
                    DateFormatter.formatDateFromString(date),
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
