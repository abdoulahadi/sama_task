import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/utils/custom_field.dart';

class TaskForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String? priority;
  final String formTitle;
  final VoidCallback onSubmit;

  const TaskForm({super.key, 
    required this.titleController,
    required this.contentController,
    this.priority,
    required this.formTitle,
    required this.onSubmit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Text(
          widget.formTitle,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        CustomField(
          controller: widget.titleController,
          labelText: 'Title',
        ),
        CustomField(
          controller: widget.contentController,
          labelText: 'Content',
          maxLines: 5, 
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField<String>(
            value: selectedPriority,
            decoration: InputDecoration(
              labelText: 'Priority',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue[50],
            ),
            items: ['Basse', 'Moyenne', 'Élevée']
                .map((label) => DropdownMenuItem(
                      value: label,
                      child: Text(label),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: widget.onSubmit,
            child: Text(
              widget.formTitle == 'Add Task' ? 'Create' : 'Update',
              style: const TextStyle(
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
