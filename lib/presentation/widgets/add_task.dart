import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/utils/custom_field.dart';

class TaskForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController dueToController;
  final String? initialPriority;
  final String formTitle;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final void Function(String?)? onPriorityChanged;
  final GlobalKey<FormState>? formKey;

  const TaskForm({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.dueToController,
    this.initialPriority,
    required this.formTitle,
    required this.submitButtonText,
    required this.onSubmit,
    this.onPriorityChanged,
    this.formKey,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority;
  }

    Future<void> _selectDueToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.dueToController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.formTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          CustomField(
            controller: widget.titleController,
            labelText: 'Title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un titre';
              }
              return null;
            },
          ),
          CustomField(
            controller: widget.contentController,
            labelText: 'Content',
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir du contenu';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: widget.dueToController,
              decoration: InputDecoration(
                labelText: 'Due To',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.lightBlue[50],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDueToDate(context),
                ),
              ),
              readOnly: true, // Empêche l'utilisateur de taper manuellement
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une date d\'échéance';
                }
                return null;
              },
            ),
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
                widget.onPriorityChanged?.call(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une priorité';
                }
                return null;
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
                widget.submitButtonText,
                style: const TextStyle(
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
