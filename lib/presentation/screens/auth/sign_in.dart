import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/services/user.dart';
import 'package:sama_task/core/utils/custom_field.dart';
import 'package:sama_task/data/models/user.dart';
import 'package:sama_task/data/repositories/shared_preferences.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';
import 'package:sama_task/presentation/screens/home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserService _userService = UserService();

  Future<void> _login() async {
    try {
      final request = LoginRequest(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      final response = await _userService.login(request);
      final user = await _userService.getProfile(response.accessToken);

      print(response);
      if (response.accessToken != null) {
        await UserPreferences.saveUserInfo(
          token: response.accessToken,
          firstname: user.prenom,
          lastname: user.nom,
          username: user.username,
          photo: user.photo!,
          email: user.email!,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/samatask_logo.png',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sign in',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
            SizedBox(height: 20),
            CustomField(
              hintText: 'Username',
              controller: _usernameController,
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
              },
            ),
            SizedBox(height: 10),
            CustomField(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                }),
            SizedBox(height: 20),
            CustomButton(
              text: 'Sign in',
              color: AppColors.secondary,
              onPressed: _login,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/signUp'),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: AppColors.background),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
