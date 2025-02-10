import 'package:flutter/material.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';
import 'package:sama_task/presentation/screens/auth/widget/custom_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: AppColors.background),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Cheikh Abdoul Ahad",
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INFORMATIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informations",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CustomField(
                    value: "Cheikh Abdoul Ahad",
                    hint: "Name",
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  const CustomField(
                    value: "+221 78 XXX XX XX",
                    hint: "Phone Number",
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  const CustomField(
                    value: "samatask@mail.com",
                    hint: "Email",
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  const CustomField(
                    value: "********************",
                    hint: "Password",
                    obscureText: true,
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // BOUTON UPDATE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "Update",
                route: "/updateProfile",
                context: context,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
