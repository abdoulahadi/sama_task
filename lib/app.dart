import 'package:flutter/material.dart';
import 'package:sama_task/core/services/task.dart';
import 'package:sama_task/data/repositories/shared_preferences.dart';
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
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/start': (context) => StartScreen(),
        '/signIn': (context) => SignInScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfilePage(),
        '/allTasks': (context) => const AllTasksScreen(),
      },
    );
  }
}

// ignore: must_be_immutable
class AuthWrapper extends StatelessWidget {
  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    String? token = await UserPreferences.getToken();
    if (token != null) {
      final taskService = TaskService();
      await taskService.syncPendingActions(token); 
    }
  }

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else {
          return FutureBuilder<String?>(
            future: UserPreferences.getToken(),
            builder: (context, tokenSnapshot) {
              if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (tokenSnapshot.hasError) {
                return Center(child: Text('Erreur : ${tokenSnapshot.error}'));
              } else if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: StartScreen(),
                );
              } else {
                return WillPopScope(
                  onWillPop: () async => false, 
                  child: Home(),
                );
              }
            },
          );
        }
      },
    );
  }
}