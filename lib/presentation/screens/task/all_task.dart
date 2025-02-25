import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/constants/app_strings.dart';
import 'package:sama_task/core/services/task.dart';
import 'package:sama_task/data/models/task.dart';
import 'package:sama_task/data/repositories/shared_preferences.dart';
import 'package:sama_task/presentation/widgets/task_item.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  late Future<List<Task>> _tasksFuture;
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late String? _token = '';

  @override
void initState() {
  super.initState();
  _initialize();
  _searchController.addListener(_updateSearchQuery);
}

Future<void> _initialize() async {
  String? token = await UserPreferences.getToken();
  setState(() {
    _token = token;
    _tasksFuture = TaskService().getAll(_token!);
  });
}

  void _updateSearchQuery() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  List<Task> _applyFilters(List<Task> tasks) {
    return tasks.where((task) {
      final matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery) ||
          (task.content?.toLowerCase().contains(_searchQuery) ?? false);

      final matchesPriority = _selectedFilter == 'Tous' ||
          AppStrings.getPriorityLabel(task.priority) == _selectedFilter;

      return matchesSearch && matchesPriority;
    }).toList();
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Tous', _selectedFilter == 'Tous'),
                _buildFilterButton('Élevée', _selectedFilter == 'Élevée'),
                _buildFilterButton('Moyenne', _selectedFilter == 'Moyenne'),
                _buildFilterButton('Basse', _selectedFilter == 'Basse'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }

                  final tasks = _applyFilters(snapshot.data ?? []);

                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks found'));
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskItem(
                        id: task.id!,
                        title: task.title,
                        date: DateFormat('dd/MM/yyyy').format(task.dueDate),
                        color: AppColors.getPriorityColor(task.priority),
                        content: task.content ?? 'No description',
                        priority: task.priority,
                        dueDate: task.dueDate,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
