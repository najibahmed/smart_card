import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/card_model.dart';

class AddOrEditController extends GetxController {
  var nameController = TextEditingController().obs;
  var jobController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var companyController = TextEditingController().obs;
  var websiteUrlController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var linkedInProfileController = TextEditingController().obs;
  var twitterHandleController = TextEditingController().obs;
  RxBool isNew = false.obs;
  bool isEdit = Get.arguments?['isEdit'] ?? false;
  String? email;
  Rx<File?> profilePic = Rx<File?>(null);

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('cards');

/// pick image method
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Show a bottom sheet with options to choose between camera and gallery
    final XFile? image = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      // Handle the picked image file (e.g. display it in an Image widget)
      profilePic.value = File(image.path);
      print('Image selected: ${image.path}');
      // Do something with the image file, like uploading or displaying it
    }else{
      profilePic.value = File('');
    }
  }
  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProfileImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask =  photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
  @override
  void onInit() {
    super.onInit();
    email = Hive.box('userBox').get('email');
  }

  void initialize(CardModel user) {

    nameController.value.text = user.name;
    jobController.value.text = user.job;
    emailController.value.text = user.email;
    phoneController.value.text = user.phone;
    companyController.value.text = user.company;
    websiteUrlController.value.text = user.websiteUrl;
    addressController.value.text = user.address;
    linkedInProfileController.value.text = user.linkedInProfile;
    twitterHandleController.value.text = user.twitterHandle;
  }

  Future<void> saveChanges() async {
    final dialog = showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Saving...'),
          content: SizedBox(
            height: 50,
            width: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );

    try {
      if (!isEdit) {
        var newRef = _dbRef.push();
        CardModel updatedCard = CardModel(
          name: nameController.value.text,
          job: jobController.value.text,
          email: emailController.value.text,
          phone: phoneController.value.text,
          company: companyController.value.text,
          websiteUrl: websiteUrlController.value.text,
          address: addressController.value.text,
          linkedInProfile: linkedInProfileController.value.text,
          twitterHandle: twitterHandleController.value.text,
          profileImageUrl: '', // Dummy or empty if not updating
          identifier: email!,
        );
        await newRef.set(updatedCard.toMap());
        Future.delayed(Duration(milliseconds: 500), () {
          Get.back();
          Get.snackbar(
            "Success",
            "New card created successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      } else {
        String? downloadUrl;
        if(profilePic.value == null) {
          Get.snackbar(
            "Error",
            'Please select a product image!',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        // Find the existing entry by identifier (email)
        final snapshot = await _dbRef.orderByChild('identifier').equalTo(email).once();
        if (snapshot.snapshot.exists) {
         // downloadUrl = await uploadImage(profilePic.value!.path);
          final data = snapshot.snapshot.value as Map;
          final entryKey = data.keys.first;
          CardModel updatedCard = CardModel(
            name: nameController.value.text,
            job: jobController.value.text,
            email: emailController.value.text,
            phone: phoneController.value.text,
            company: companyController.value.text,
            websiteUrl: websiteUrlController.value.text,
            address: addressController.value.text,
            linkedInProfile: linkedInProfileController.value.text,
            twitterHandle: twitterHandleController.value.text,
            profileImageUrl: '', // Dummy or empty if not updating
            identifier: email!,
          );// Get the key of the entry to be updated
          await _dbRef.child(entryKey).update(updatedCard.toMap());
          Get.back();
          Get.snackbar(
            "Success",
            "Card updated successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Error",
            "Card not found for the given identifier.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        "Error",
        "Failed to save data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      Navigator.of(Get.context!).pop(); // Close the loading dialog
    }
  }
}
