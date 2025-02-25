import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/constants/app_strings.dart';
import 'package:sama_task/core/services/task.dart';
import 'package:sama_task/core/utils/convert_to_color.dart';
import 'package:sama_task/core/utils/format_date.dart';
import 'package:sama_task/data/models/task.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';
import 'package:sama_task/presentation/widgets/add_task.dart';
import 'package:share_plus/share_plus.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final String jwt;

  const TaskDetailPage({
    Key? key,
    required this.task,
    required this.jwt,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task _task;

  void _shareTask() {
    final String textToShare =
        "Tâche: ${_task.title}\n\n${_task.content ?? ''}";
    Share.share(textToShare);
  }

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

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
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: hexToColor(_task.color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _task.title,
                style: const TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _task.content!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateFormatter.formatDate( _task.dueDate),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                CustomButton(
                  text: "Update",
                  onPressed: () {
                    _showUpdateTaskForm(context, _task);
                  },
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Delete",
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmer la suppression"),
                        content: const Text(
                            "Êtes-vous sûr de vouloir supprimer cette tâche ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Supprimer"),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await TaskService().delete(widget.jwt, _task.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tâche supprimée")),
                        );
                        Navigator.pushNamed(context, "/home");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Erreur lors de la suppression")),
                        );
                      }
                    }
                  },
                  color: AppColors.error,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Partager",
                  onPressed: _shareTask,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showUpdateTaskForm(BuildContext context, Task task) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController contentController =
        TextEditingController(text: task.content);

    final TextEditingController dueToController =
        TextEditingController(text: task.dueDate.toString());
    TaskPriority? selectedPriority = task.priority;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: TaskForm(
              formKey: formKey,
              titleController: titleController,
              contentController: contentController,
              dueToController: dueToController,
              initialPriority: AppStrings.getPriorityLabel(selectedPriority!),
              formTitle: "Update Task",
              submitButtonText: "Update",
              onSubmit: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final updatedTask = Task(
                      id: task.id,
                      title: titleController.text,
                      content: contentController.text,
                      priority: selectedPriority!,
                      color: AppColors.getPriorityColor(selectedPriority!)
                          .toString(),
                      dueDate: DateTime.parse(dueToController.text),
                    );

                    await TaskService().update(widget.jwt, updatedTask);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tâche mise à jour")),
                    );
                    setState(() {
                      _task = updatedTask;
                    });
                    Navigator.pushNamed(context, "/home");
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Erreur lors de la mise à jour")),
                    );
                  }
                }
              },
              onPriorityChanged: (value) {
                selectedPriority = AppStrings.getLabelPriority(value!);
              },
            ),
          ),
        );
      },
    );
  }
}
