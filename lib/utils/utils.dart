import "dart:io";
import "dart:typed_data";

import "package:image_picker/image_picker.dart";
import "package:flutter/material.dart";

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

bool isValidEmail(String email) {
  // Regular expression for validating email addresses
  String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  RegExp regex = RegExp(pattern);

  // Check if the provided email matches the pattern
  return regex.hasMatch(email);
}
