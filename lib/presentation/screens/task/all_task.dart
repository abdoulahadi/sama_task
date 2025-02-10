import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/widgets/task_item.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All tasks',
          style: TextStyle(
              color: AppColors.background,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search a task',
                  hintStyle:
                      TextStyle(color: AppColors.background.withOpacity(0.6)),
                  icon: const Icon(Icons.search, color: AppColors.background),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Tous', true),
                _buildFilterButton('Élevée', false),
                _buildFilterButton('Moyenne', false),
                _buildFilterButton('Basse', false),
              ],
            ),
            const SizedBox(height: 16),

            // Tasks List
            Expanded(
              child: ListView(
                children: const [
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.basse,
                      content: 'Supporting line text lorem .....'),
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.moyenne,
                      content: 'Supporting line text lorem .....'),
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.elevee,
                      content: 'Supporting line text lorem .....'),
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.elevee,
                      content: 'Supporting line text lorem .....'),
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.basse,
                      content: 'Supporting line text lorem .....'),
                  TaskItem(
                      title: 'Task title',
                      date: '25/01/2025',
                      color: AppColors.moyenne,
                      content: 'Supporting line text lorem .....'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.background : AppColors.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
