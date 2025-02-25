import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/services/user.dart';
import 'package:sama_task/core/utils/custom_field.dart';
import 'package:sama_task/data/models/user.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserService _userService = UserService();

  Future<void> _register() async {
    try {
      final request = RegisterRequest(
        nom: _lastnameController.text,
        prenom: _firstnameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        photo: 'assets/images/profile.jpeg',
      );

      final response = await _userService.register(request);

      if (response.id != null) {
        Navigator.pushNamed(context, '/signIn');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'inscription')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'inscription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/samatask_logo.png',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(height: 20),
              CustomField(
                hintText: 'Last Name',
                controller: _lastnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomField(
                hintText: 'First Name',
                controller: _firstnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              CustomField(
                hintText: 'Email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomField(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Sign up',
                onPressed: _register,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signIn'),
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: AppColors.background),
                    children: [
                      TextSpan(
                        text: "Sign in",
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
      ),
    );
  }
}
