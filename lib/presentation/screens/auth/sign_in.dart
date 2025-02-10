// lib/screens/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';
import 'package:sama_task/presentation/screens/auth/widget/custom_field.dart';

class SignInScreen extends StatelessWidget {
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
            CustomField(hint: 'Email'),
            SizedBox(height: 10),
            CustomField(hint: 'Password', obscureText: true),
            SizedBox(height: 20),
            CustomButton(
              text: 'Sign in',
              route: '/home',
              context: context,
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
