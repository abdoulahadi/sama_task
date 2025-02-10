import 'package:flutter/material.dart';
import 'package:sama_task/presentation/screens/auth/sign_in.dart';
import 'package:sama_task/presentation/screens/auth/sign_up.dart';
import 'package:sama_task/presentation/screens/profile/profile.dart';
import 'package:sama_task/presentation/screens/home/home_screen.dart';
import 'package:sama_task/presentation/screens/start/start.dart';
import 'package:sama_task/presentation/screens/task/all_task.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Tâches',
      theme: AppTheme.lightTheme,
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/start': (context) =>  StartScreen(),
        '/signIn': (context) =>  SignInScreen(),
        '/signUp': (context) =>  SignUpScreen(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfilePage(),
        '/allTasks': (context) => const AllTasksScreen(),
      },
    );
  }
}
