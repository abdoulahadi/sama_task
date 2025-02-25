import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sama_task/data/models/user.dart';

ImageProvider getProfileImage(File? image, User user) {
  if (image != null && image.existsSync()) {
    return FileImage(image);
  } else if (user.photo != null && user.photo!.isNotEmpty) {
    if (user.photo!.startsWith('http')) {
      return NetworkImage(user.photo!);
    } else if (user.photo!.startsWith('/')) {
      final file = File(user.photo!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
  }
  
  return const AssetImage('assets/images/profile.jpeg');
}