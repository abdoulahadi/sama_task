import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/services/task.dart';
import 'package:sama_task/core/services/user.dart';
import 'package:sama_task/core/utils/convert_to_color.dart';
import 'package:sama_task/core/utils/image_view.dart';
import 'package:sama_task/data/models/task.dart';
import 'package:sama_task/data/models/user.dart';
import 'package:sama_task/data/repositories/shared_preferences.dart';
import 'package:sama_task/presentation/screens/auth/sign_in.dart';
import 'package:sama_task/presentation/screens/home/header.dart';
import 'package:sama_task/presentation/widgets/add_task.dart';
import 'package:sama_task/presentation/widgets/task_item.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String? _token = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _initialize() async {
    String? token = await UserPreferences.getToken();
    setState(() {
      _token = token;
    });
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dueToController = TextEditingController();
  String? selectedPriority;

  final TaskService _taskService = TaskService();
  final UserService _userService = UserService();
  late User _user = User(
    id: 0,
    nom: '',
    prenom: '',
    username: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  List<Task> _lastTasks = [];
  bool _isLoading = true;
  int _lowCount = 0;
  int _mediumCount = 0;
  int _highCount = 0;

  Future<void> _fetchTasks() async {
    try {
      await _initialize();
      List<Task> tasks = await _taskService.getAll(_token!);
      print(tasks);
      tasks.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      setState(() {
        _lastTasks = tasks.take(5).toList();

        _lowCount = tasks.where((t) => t.priority == TaskPriority.low).length;
        _mediumCount =
            tasks.where((t) => t.priority == TaskPriority.medium).length;
        _highCount = tasks.where((t) => t.priority == TaskPriority.high).length;
        _isLoading = false;
      });
      await _getProfile();
      _loadSavedImage();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getProfile() async {
    try {
      User user = await _userService.getProfile(_token!);
      // print(
      //     "User reçu: nom='${user.nom}', prenom='${user.prenom}', username='${user.username}', email='${user.email ?? "null"}'");
      setState(() {
        _user = user;
      });

      print(user);
    } catch (e) {
      print("Erreur lors de la récupération du profil: $e");
    }
  }

  void _loadSavedImage() async {
    if (_user.photo != null) {
      final imageFile = File(_user.photo!);
      if (await imageFile.exists()) {
        setState(() {
          _image = imageFile;
        });
      }
    }
  }

  Future<void> _addTask() async {
    print(_token!);
    try {
      TaskPriority priority = TaskPriority.low;
      if (selectedPriority == 'Moyenne') priority = TaskPriority.medium;
      if (selectedPriority == 'Élevée') priority = TaskPriority.high;

      Task newTask = Task(
        title: titleController.text,
        content: contentController.text,
        priority: priority,
        color: AppColors.getPriorityColor(priority).toString(),
        dueDate: DateTime.parse(dueToController.text),
      );

      await _taskService.create(_token!, newTask);
      _fetchTasks();
      Navigator.pop(context);
    } catch (e) {
      print("Erreur lors de l'ajout de la tâche: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    void showTaskForm(
        {required String formTitle, required VoidCallback onSubmit}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TaskForm(
                titleController: titleController,
                contentController: contentController,
                dueToController: dueToController,
                formTitle: formTitle,
                submitButtonText: "Add Task",
                onSubmit: onSubmit,
                onPriorityChanged: (priority) {
                  setState(() {
                    selectedPriority = priority;
                  });
                },
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16.0 * 3, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  children: [
                    const TextSpan(text: "Welcome back ! "),
                    TextSpan(
                      text: _user.nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print(
                      "Navigation vers /profile avec : User = $_user, Token = $_token");

                  Navigator.pushNamed(
                    context,
                    '/profile',
                    arguments: {
                      'user': _user,
                      'token': _token,
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      _isLoading ? null : getProfileImage(_image, _user),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SamaTaskHeader(
                  lowCount: _lowCount,
                  mediumCount: _mediumCount,
                  highCount: _highCount),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/allTasks');
                    },
                    child: const Text('view all'),
                  ),
                ],
              ),
              SizedBox(
                height: 400,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _lastTasks.isEmpty
                        ? const Center(child: Text('Aucune tâche disponible.'))
                        : ListView.builder(
                            itemCount: _lastTasks.length,
                            itemBuilder: (context, index) {
                              final task = _lastTasks[index];
                              return TaskItem(
                                id: task.id!,
                                title: task.title,
                                content: task.content ?? '',
                                dueDate: task.dueDate,
                                priority: task.priority,
                                date: task.dueDate.toIso8601String(),
                                color: hexToColor(task.color),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: AppColors.primary,
        children: [
          SpeedDialChild(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            shape: const CircleBorder(),
            child: const Icon(Icons.logout),
            onTap: () async {
              await UserPreferences.clearUserInfo();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
                (Route<dynamic> route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have been logged out successfully.'),
                ),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
            onTap: () {
              showTaskForm(
                formTitle: 'Add a Task',
                onSubmit: _addTask,
              );
            },
          ),
        ],
      ),
    );
  }
}
