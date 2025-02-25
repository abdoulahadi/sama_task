import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sama_task/core/constants/app_colors.dart';
import 'package:sama_task/core/services/user.dart';
import 'package:sama_task/core/utils/custom_field.dart';
import 'package:sama_task/core/utils/image_view.dart';
import 'package:sama_task/presentation/screens/auth/widget/build_button.dart';
import 'package:sama_task/data/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user = User(
    id: 0,
    nom: '',
    prenom: '',
    username: '',
    email: '',
    photo: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  late String _token = '';

  // Déclarer les contrôleurs sans les initialiser
  late final TextEditingController _lastnameController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  
  File? _image;
  final _picker = ImagePicker();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    
    // Initialiser les contrôleurs
    _lastnameController = TextEditingController();
    _firstnameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    // Libérer les ressources
    _lastnameController.dispose();
    _firstnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$uniqueFileName');
      
      setState(() {
        _image = savedImage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image sélectionnée avec succès")),
      );

    } catch (e) {
      print("Erreur lors de la copie de l'image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection de l'image: $e")),
      );
    }
  }
}

  Future<void> _updateProfile() async {
    try {
      final updatedUser = await _userService.updateProfile(
        _token,
        UpdateUserRequest(
          nom: _lastnameController.text,
          prenom: _firstnameController.text,
          username: _usernameController.text,
          email: _emailController.text,
          photo: _image?.path,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_photo', _image!.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: \$e")),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    print("didChangeDependencies() - Arguments reçus : $args");
    

    if (args != null && args is Map<String, dynamic>) {
      User user = args['user'];
      String token = args['token'] as String;
      print("User reçu: nom='${user.nom}', prenom='${user.prenom}', username='${user.username}', email='${user.email ?? "null"}'");
      print("Token reçu: $token");
      setState(() {
        _user = user;
        _token = token;
        _firstnameController.text = user.prenom;
        _lastnameController.text = user.nom;
        _usernameController.text = user.username;
        _emailController.text = user.email ?? '';
      });
    } else {
      print("Aucun argument reçu !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(color: AppColors.background)),
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      // backgroundImage: _image != null
                      //     ? FileImage(_image!)
                      //     : (_user.photo != null && _user.photo!.isNotEmpty
                      //         ? NetworkImage(_user.photo!) as ImageProvider
                      //         : const AssetImage('assets/images/profile.jpeg')),
                      backgroundImage: getProfileImage(_image, _user),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_user.nom,
                      style: const TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informations",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
                  CustomField(
                      hintText: "Nom",
                      textColor: AppColors.primary,
                      controller: _lastnameController),
                  const SizedBox(height: 10),
                  CustomField(
                      hintText: "Prénom",
                      textColor: AppColors.primary,
                      controller: _firstnameController),
                  const SizedBox(height: 10),
                  CustomField(
                      hintText: "Username",
                      textColor: AppColors.primary,
                      controller: _usernameController),
                  const SizedBox(height: 10),
                  CustomField(
                      hintText: "Email",
                      textColor: AppColors.primary,
                      controller: _emailController),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                  text: "Update",
                  onPressed: _updateProfile,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}