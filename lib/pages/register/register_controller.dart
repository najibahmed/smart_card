import 'package:card/pages/home/home_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('users');

  bool validateForm() {
    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name cannot be empty';
      isValid = false;
    } else {
      nameError.value = '';
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Password cannot be empty';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  void registerUser() async {
    if (validateForm()) {
      try {
        // Check if the user already exists
        final snapshot = await _dbRef
            .orderByChild('email')
            .equalTo(emailController.text.trim())
            .once();

        if (snapshot.snapshot.exists) {
          Get.snackbar(
            "Error",
            "Email is already in use.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          // Create new user entry in Firebase
          String userId = _dbRef.push().key!;
          await _dbRef.child(userId).set({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          });

          // Store user data in Hive
          var box = Hive.box('userBox');
          box.put('email', emailController.text.trim());
          box.put('userId', userId);
          box.put('name', nameController.text.trim());

          Get.snackbar(
            "Success",
            "Registration successful!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to the home screen or another page
          Get.to(HomeView()); // Replace with your home screen route
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Registration failed: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
