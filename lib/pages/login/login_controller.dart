import 'package:card/pages/home/home_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = ''.obs;
  final passwordError = ''.obs;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  bool validateForm() {
    bool isValid = true;

    if (emailController.text.trim().isEmpty || !GetUtils.isEmail(emailController.text.trim())) {
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

  void loginUser() async {
    if (validateForm()) {
      try {
        final snapshot = await _dbRef
            .orderByChild('email')
            .equalTo(emailController.text.trim())
            .once();

        if (snapshot.snapshot.exists) {
          Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
          String storedPassword = userData.values.first['password'];
          if (storedPassword == passwordController.text.trim()) {
            // Store user data in Hive
            var box = Hive.box('userBox');
            box.put('email', emailController.text.trim());
            box.put('userId', userData.keys.first); // Assuming 'userId' is the key
            box.put('name', userData.values.first['name']); // Storing additional user data
            Get.to(HomeView());
            Get.snackbar(
              "Success",
              "Login successful!",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );

            // Navigate to the home screen or dashboard
          } else {
            Get.snackbar(
              "Error",
              "Invalid password.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "User not found.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Login failed: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
