import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/widgets/add_task.dart';
import 'package:sama_task/presentation/widgets/priority_card.dart';
import 'package:sama_task/presentation/widgets/task_item.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    void showTaskForm(
        {required String formTitle, required VoidCallback onSubmit}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context)
                .viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TaskForm(
                titleController: titleController,
                contentController: contentController,
                formTitle: formTitle,
                onSubmit: onSubmit,
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
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  children: [
                    TextSpan(text: "Welcome back ! "),
                    TextSpan(
                      text: "Cheikh Diop",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      "assets/images/profile.jpeg"),
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
              const SamaTaskHeader(),
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
              const SizedBox(
                height: 400,
                child: LastTask(),
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
            onTap: () {
              Navigator.pushNamed(context, '/signIn');
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
                onSubmit: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SamaTaskHeader extends StatelessWidget {
  const SamaTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 1.2,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/samatask_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3, // Nombre de colonnes
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Empêcher la défilement indépendante
          children: const [
            PriorityCard(number: 12, priority: 'Basse'),
            PriorityCard(number: 10, priority: 'Moyenne'),
            PriorityCard(number: 07, priority: 'Elevée'),
          ],
        ),
      ],
    );
  }
}

class LastTask extends StatelessWidget {
  const LastTask({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        TaskItem(
          title: 'Acheter des fournitures',
          content: 'Acheter des fournitures ..',
          date: '12/09/2021',
          color: AppColors.basse,
        ),
        TaskItem(
          title: 'Réunion avec l\'équipe',
          content: 'Réunion avec l\'équipe .',
          date: '15/09/2021',
          color: AppColors.moyenne,
        ),
        TaskItem(
          title: 'Préparer le rapport',
          content: 'Préparer le rapport *',
          date: '20/09/2021',
          color: AppColors.elevee,
        ),
      ],
    );
  }
}
